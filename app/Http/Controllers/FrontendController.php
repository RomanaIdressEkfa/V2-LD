<?php

namespace App\Http\Controllers;

use App\Models\Debate;
use App\Models\Argument;
use App\Models\Vote;
use App\Models\User;
use App\Models\DebateParticipant;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class FrontendController extends Controller
{
   public function index(Request $request) { 
    $debate = Debate::where('status', 'active')->latest()->first();
    $roots = collect();

    if ($debate) {
        $query = $debate->arguments()
            ->whereNull('parent_id')
            ->with(['user', 'votes', 'replies.user', 'replies.votes'])
            ->withCount('votes'); 

        if ($request->get('sort') == 'latest') {
            $query->latest(); 
        } else {
            $query->orderBy('votes_count', 'desc')->latest();
        }

        $roots = $query->get();
    }

    $userSide = null;
    if(Auth::check() && $debate) {
        $participant = DebateParticipant::where('debate_id', $debate->id)
            ->where('user_id', Auth::id())
            ->first();
        
        if($participant) {
            $userSide = $participant->side;
        }
    }

    return view('home', compact('debate', 'roots', 'userSide'));
}

    public function showJoinForm($debateId) {
        $debate = Debate::findOrFail($debateId);
    
        if(Auth::check()) {
            $participant = DebateParticipant::where('debate_id', $debateId)
                ->where('user_id', Auth::id())
                ->exists();
            
            if($participant) {
                return redirect()->route('home')->with('info', 'You have already joined this debate.');
            }
        }

        return view('frontend.auth.debate-join', compact('debate'));
    }

  public function processJoin(Request $request, $debateId) {
    if (Auth::check() && Auth::user()->role === 'admin') {
        Auth::logout();
        return redirect()->route('debate.join_form', $debateId)
            ->with('error', 'Please join as a regular user (not Admin).');
    }

    $user = Auth::user();

    if (!$user) {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6',
            'side' => 'required|in:pro,con',
            'avatar' => 'nullable|image|max:5120',
        ]);

        $avatarPath = null;
        if ($request->hasFile('avatar')) {
            $avatarPath = $request->file('avatar')->store('avatars', 'public');
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email, 
            'password' => Hash::make($request->password),
            'avatar' => $avatarPath,
            'role' => 'user'
        ]);

        Auth::login($user, true);
    } else {
        $request->validate([
            'side' => 'required|in:pro,con',
        ]);

        if ($request->hasFile('avatar')) {
            $request->validate(['avatar' => 'nullable|image|max:5120']);
            $user->avatar = $request->file('avatar')->store('avatars', 'public');
            $user->save();
        }
    }

    DebateParticipant::updateOrCreate(
        [
            'debate_id' => $debateId,
            'user_id' => $user->id
        ],
        [
            'side' => $request->side
        ]
    );

    return redirect()->route('home')->with('success', 'Welcome! You have registered and joined successfully.');
}
   public function storeArgument(Request $request, $debateId) {
    if(!Auth::check()) {
        return redirect()->route('debate.join_form', $debateId);
    }

    $participant = DebateParticipant::where('debate_id', $debateId)
        ->where('user_id', Auth::id())
        ->first();

    if (!$participant) {
        return redirect()->route('debate.join_form', $debateId);
    }

    // 1. Validation (Body is optional if file is present)
    $request->validate([
        'body' => 'nullable|string',
        'attachment_image' => 'nullable|image|max:10240', // 10MB
        'attachment_audio' => 'nullable|mimes:mp3,wav,ogg,m4a|max:20480', // 20MB
        'attachment_video' => 'nullable|mimes:mp4,mov,avi,webm|max:51200', // 50MB
        'attachment_doc'   => 'nullable|mimes:pdf,doc,docx|max:10240',
    ]);

    // 2. Check if EMPTY (No text AND no file)
    $hasFile = $request->hasFile('attachment_image') || $request->hasFile('attachment_audio') || $request->hasFile('attachment_video') || $request->hasFile('attachment_doc');
    $cleanBody = strip_tags($request->body, '<p><br><b><i><u><ul><ol><li><span><div>');

    if (empty(strip_tags($request->body)) && !$hasFile) {
        return back()->with('error', 'Please write something or upload a file.');
    }

    // 3. Store Files
    $imagePath = $request->file('attachment_image') ? $request->file('attachment_image')->store('uploads/images', 'public') : null;
    $audioPath = $request->file('attachment_audio') ? $request->file('attachment_audio')->store('uploads/audio', 'public') : null;
    $videoPath = $request->file('attachment_video') ? $request->file('attachment_video')->store('uploads/video', 'public') : null;
    $docPath   = $request->file('attachment_doc')   ? $request->file('attachment_doc')->store('uploads/docs', 'public') : null;

    // 4. Create Database Entry
    Argument::create([
        'debate_id' => $debateId,
        'user_id' => Auth::id(),
        'side' => $request->side ?? $participant->side, 
        'body' => $cleanBody,
        'parent_id' => $request->parent_id ?? null,
        'reply_type' => $request->reply_type ?? 'neutral',
        'attachment_image' => $imagePath,
        'attachment_audio' => $audioPath,
        'attachment_video' => $videoPath,
        'attachment_doc'   => $docPath,
    ]);

    return redirect()->back()->with('success', 'Posted successfully!');
}


public function vote(Request $request, $argumentId) {
    if(!Auth::check()) {
        return response()->json(['status' => 'login_required', 'debate_id' =>Argument::find($argumentId)->debate_id]);
    }

    $userId = Auth::id();
    $type = $request->type; 
    $existingVote = Vote::where('user_id', $userId)
                        ->where('argument_id', $argumentId)
                        ->first();

    if ($existingVote) {
        if ($existingVote->type == $type) {
            $existingVote->delete();
            $userVote = null;
        } else {
            $existingVote->update(['type' => $type]);
            $userVote = $type;
        }
    } else {
        Vote::create([
            'user_id' => $userId,
            'argument_id' => $argumentId,
            'type' => $type
        ]);
        $userVote = $type;
    }

    $argument = Argument::withCount([
        'votes as agree_count' => function ($query) { $query->where('type', 'agree'); },
        'votes as disagree_count' => function ($query) { $query->where('type', 'disagree'); }
    ])->find($argumentId);

    return response()->json([
        'status' => 'success',
        'agree_count' => $argument->agree_count,
        'disagree_count' => $argument->disagree_count,
        'user_vote' => $userVote
    ]);
}
}