@props(['node', 'debate', 'relation'])

@php
    $isPro = $node->side == 'pro';
    $borderColor = $isPro ? '#10b981' : '#ef4444'; 
    $bgColor = $isPro ? '#ecfdf5' : '#fef2f2';
    
    // Connection Badge Logic
    $connColor = '#64748b'; $connText = '';
    if($relation == 'agree') { $connColor = '#3b82f6'; $connText = 'AGREED'; } 
    elseif($relation == 'disagree') { $connColor = '#f97316'; $connText = 'DISAGREED'; }
@endphp

<li>
    <div class="card shadow-sm mb-3 text-start" style="width: 350px; border-top: 5px solid {{ $borderColor }}; border-radius: 12px; position: relative; display: inline-block;">
        
        <!-- Connection Badge -->
        @if($relation !== 'root')
            <div style="position: absolute; top: -12px; left: 50%; transform: translateX(-50%); background: {{ $connColor }}; color: white; padding: 2px 10px; border-radius: 20px; font-size: 10px; font-weight: 800; border: 2px solid white; z-index: 10;">
                {{ $connText }}
            </div>
        @endif

        <!-- Card Header -->
        <div class="card-header bg-white border-0 pt-3 d-flex justify-content-between">
            <div class="d-flex align-items-center gap-2">
                <img src="{{ $node->user->avatar ? asset('storage/'.$node->user->avatar) : 'https://ui-avatars.com/api/?name='.urlencode($node->user->name) }}" class="rounded-circle" width="30" height="30" style="object-fit:cover;">
                <div>
                    <div class="fw-bold small">{{ $node->user->name }}</div>
                    <div class="text-muted" style="font-size: 10px;">{{ $node->created_at->diffForHumans() }}</div>
                </div>
            </div>
            @if($node->replies->count() > 0)
                <i class="fas fa-minus-square text-muted" style="cursor: pointer;" onclick="toggleChildren({{ $node->id }})"></i>
            @endif
        </div>

        <!-- Card Body -->
        <div class="card-body p-2">
            
            <!-- 1. Text Content (Only show if not empty) -->
            @if(!empty(strip_tags($node->body)))
                <div class="p-2 rounded mb-2" style="background-color: {{ $bgColor }}; font-size: 13px;">
                    {!! $node->body !!}
                </div>
            @endif

            <!-- 2. IMAGE DISPLAY -->
            @if(!empty($node->attachment_image))
                <div class="mb-2 text-center">
                    <img src="{{ asset('storage/' . $node->attachment_image) }}" class="img-fluid rounded" style="max-height: 200px; width: 100%; object-fit: cover;" alt="Attachment">
                </div>
            @endif

            <!-- 3. VIDEO DISPLAY -->
            @if(!empty($node->attachment_video))
                <div class="mb-2">
                    <video controls class="w-100 rounded" style="max-height: 200px; background: #000;">
                        <source src="{{ asset('storage/' . $node->attachment_video) }}">
                        Your browser does not support the video tag.
                    </video>
                </div>
            @endif

            <!-- 4. AUDIO DISPLAY -->
            @if(!empty($node->attachment_audio))
                <div class="mb-2">
                    <audio controls class="w-100" style="height: 30px;">
                        <source src="{{ asset('storage/' . $node->attachment_audio) }}">
                    </audio>
                </div>
            @endif

            <!-- 5. DOCUMENT DOWNLOAD -->
            @if(!empty($node->attachment_doc))
                <a href="{{ asset('storage/' . $node->attachment_doc) }}" target="_blank" class="btn btn-light btn-sm w-100 border text-start">
                    <i class="fas fa-file-pdf text-danger"></i> Download Document
                </a>
            @endif
        </div>

        <!-- Footer Actions -->
        <div class="card-footer bg-white border-top-0 d-flex justify-content-between align-items-center py-1">
            <button onclick="voteArgument({{ $node->id }}, 'agree')" class="btn btn-link text-secondary p-0 text-decoration-none small">
                <i class="far fa-heart"></i> <span id="like-count-{{ $node->id }}">{{ $node->votes_count ?? 0 }}</span>
            </button>

            @if(Auth::check())
            <div class="dropdown">
                <button class="btn btn-sm text-dark fw-bold dropdown-toggle" data-bs-toggle="dropdown">Reply</button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item small fw-bold text-success" href="#" onclick="toggleReplyBox({{ $node->id }}, 'agree')">Agree</a></li>
                    <li><a class="dropdown-item small fw-bold text-danger" href="#" onclick="toggleReplyBox({{ $node->id }}, 'disagree')">Disagree</a></li>
                </ul>
            </div>
            @endif
        </div>

        <!-- Reply Input Box -->
        <div id="reply-box-{{ $node->id }}" class="reply-box collapse p-2 bg-light border-top">
            <form action="{{ route('argument.store', $debate->id) }}" method="POST" enctype="multipart/form-data">
                @csrf
                <input type="hidden" name="parent_id" value="{{ $node->id }}">
                <input type="hidden" name="reply_type" id="type-input-{{ $node->id }}" value="neutral">
                
                <textarea name="body" class="form-control mb-2" rows="2" placeholder="Write a reply..."></textarea>
                
                <div class="d-flex gap-2 mt-2 align-items-center">
                    <label class="btn btn-sm btn-outline-secondary py-0" title="Upload Image"><i class="fas fa-image"></i> <input type="file" name="attachment_image" class="hidden-input"></label>
                    <label class="btn btn-sm btn-outline-secondary py-0" title="Upload Video"><i class="fas fa-video"></i> <input type="file" name="attachment_video" class="hidden-input"></label>
                    <button type="submit" id="reply-btn-{{ $node->id }}" class="btn btn-sm fw-bold ms-auto text-white">Post</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Recursive Children -->
    @if($node->replies->count() > 0)
        <ul id="children-{{ $node->id }}">
            @foreach($node->replies as $reply)
                @php $rel = $reply->reply_type ?? ($reply->side == $node->side ? 'agree' : 'disagree'); @endphp
                @include('frontend.partials.comment_tree', ['node' => $reply, 'debate' => $debate, 'relation' => $rel])
            @endforeach
        </ul>
    @endif
</li>