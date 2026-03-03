<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>{{ $debate->title ?? 'DebateLogic' }}</title>
    <link rel="icon" href="https://i.ibb.co.com/s916M5xG/Logo-01.png" type="image/png">

    <!-- Bootstrap 5 & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Summernote -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">

    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', sans-serif; padding-top: 80px; }
        
        /* NAVBAR */
        .navbar { background: white; border-bottom: 1px solid #e2e8f0; height: 70px; }
        .navbar-brand img { height: 40px; }

        /* WIDE DESIGN CSS */
        .tree-wrapper {
            width: 100%;
            overflow-x: auto; /* Allow side scrolling */
            padding-bottom: 100px;
        }

        .tree-container {
            display: flex;
            justify-content: center;
            /* Ensure it doesn't shrink */
            min-width: 1000px; 
            gap: 60px;
            padding-top: 30px;
        }

        .tree-column {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* HEADER BADGES */
        .col-badge {
            padding: 10px 40px; border-radius: 50px; color: white; font-weight: 800; font-size: 16px;
            text-transform: uppercase; letter-spacing: 1px; margin-bottom: 30px; 
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .badge-pro { background: #10b981; }
        .badge-con { background: #ef4444; }

        /* TREE LINES */
        .tree ul { padding-top: 20px; position: relative; display: flex; justify-content: center; padding-left: 0; }
        .tree li { float: left; text-align: center; list-style-type: none; position: relative; padding: 20px 10px 0 10px; }
        
        /* Connectors */
        .tree li::before, .tree li::after {
            content: ''; position: absolute; top: 0; right: 50%; border-top: 2px solid #ccc; width: 50%; height: 20px; z-index: -1;
        }
        .tree li::after { right: auto; left: 50%; border-left: 2px solid #ccc; }
        .tree li:only-child::after, .tree li:only-child::before { display: none; }
        .tree li:only-child { padding-top: 0; }
        .tree li:first-child::before, .tree li:last-child::after { border: 0 none; }
        .tree li:last-child::before { border-right: 2px solid #ccc; border-radius: 0 5px 0 0; }
        .tree li:first-child::after { border-radius: 5px 0 0 0; }
        .tree ul ul::before {
            content: ''; position: absolute; top: 0; left: 50%; border-left: 2px solid #ccc; width: 0; height: 20px;
        }

        /* INPUT CARD DESIGN */
        .root-input-card {
            background: white; padding: 20px; border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            max-width: 850px; margin: 0 auto 50px auto;
            border: 1px solid #e2e8f0;
        }

        .media-toolbar {
            display: flex; gap: 10px; margin-top: 15px; background: #f1f5f9; padding: 10px; border-radius: 8px; align-items: center;
        }
        .media-btn {
            background: white; border: 1px solid #cbd5e1; padding: 5px 12px; border-radius: 6px; 
            font-size: 13px; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 6px;
        }
        .media-btn:hover { background: #e2e8f0; }
        .hidden-input { display: none; }

        #file-name-display { font-size: 13px; color: #10b981; font-weight: 600; margin-left: auto; }

        .action-buttons { display: flex; gap: 15px; margin-top: 15px; }
        .btn-submit { flex: 1; padding: 12px; font-weight: 800; border: none; color: white; border-radius: 8px; }
        .btn-submit.pro { background: #10b981; }
        .btn-submit.con { background: #ef4444; }

    </style>
</head>
<body>

    <nav class="navbar fixed-top">
        <div class="container-fluid px-5">
            <a class="navbar-brand" href="#"><img src="https://i.ibb.co.com/gbLB6Dqj/Logo-02.png" alt="Logo"></a>
            <div>
                @auth <strong>{{ Auth::user()->name }}</strong> @else <a href="{{ route('login') }}" class="btn btn-dark btn-sm">Login</a> @endauth
            </div>
        </div>
    </nav>

    <div class="container-fluid px-0">
        @if($debate)
            <!-- Title -->
            <div class="text-center my-4">
                <h2 class="fw-bold">{{ $debate->title }}</h2>
                @if(!Auth::check() || !$userSide)
                    <div class="d-flex justify-content-center gap-3 mt-3">
                        <form action="{{ route('debate.join', $debate->id) }}" method="POST">@csrf <button name="side" value="pro" class="btn btn-success fw-bold">Join PRO</button></form>
                        <form action="{{ route('debate.join', $debate->id) }}" method="POST">@csrf <button name="side" value="con" class="btn btn-danger fw-bold">Join CON</button></form>
                    </div>
                @endif
            </div>

            <!-- Root Input -->
            @if(Auth::check() && $userSide)
            <div class="root-input-card">
                <h5 class="fw-bold mb-3 text-center">Post a New Argument</h5>
                <form action="{{ route('argument.store', $debate->id) }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    <textarea id="rootEditor" name="body"></textarea>
                    
                    <!-- Media Toolbar -->
                    <div class="media-toolbar">
                        <span class="text-muted small fw-bold">Attach:</span>
                        <label class="media-btn"><i class="fas fa-image text-primary"></i> Image <input type="file" name="attachment_image" class="hidden-input" onchange="showFileName(this)"></label>
                        <label class="media-btn"><i class="fas fa-video text-success"></i> Video <input type="file" name="attachment_video" class="hidden-input" onchange="showFileName(this)"></label>
                        <label class="media-btn"><i class="fas fa-microphone text-danger"></i> Audio <input type="file" name="attachment_audio" class="hidden-input" onchange="showFileName(this)"></label>
                        <label class="media-btn"><i class="fas fa-file-pdf text-warning"></i> Doc <input type="file" name="attachment_doc" class="hidden-input" onchange="showFileName(this)"></label>
                        
                        <!-- File Name Display (Fixed Location) -->
                        <span id="file-name-display"></span>
                    </div>

                    <div class="action-buttons">
                        <button type="submit" name="side" value="pro" class="btn-submit pro">AGREE (Pro)</button>
                        <button type="submit" name="side" value="con" class="btn-submit con">DISAGREE (Con)</button>
                    </div>
                </form>
            </div>
            @endif

            <!-- THE WIDE TREE -->
            <div class="tree-wrapper">
                <div class="tree-container tree">
                    <div class="tree-column">
                        <div class="col-badge badge-pro">PRO ARGUMENTS</div>
                        @if($roots->where('side', 'pro')->count() > 0)
                            <ul>
                                @foreach($roots->where('side', 'pro') as $node)
                                    @include('frontend.partials.comment_tree', ['node' => $node, 'debate' => $debate, 'relation' => 'root'])
                                @endforeach
                            </ul>
                        @else
                            <p class="text-muted">No arguments yet.</p>
                        @endif
                    </div>

                    <div class="tree-column">
                        <div class="col-badge badge-con">CON ARGUMENTS</div>
                        @if($roots->where('side', 'con')->count() > 0)
                            <ul>
                                @foreach($roots->where('side', 'con') as $node)
                                    @include('frontend.partials.comment_tree', ['node' => $node, 'debate' => $debate, 'relation' => 'root'])
                                @endforeach
                            </ul>
                        @else
                            <p class="text-muted">No arguments yet.</p>
                        @endif
                    </div>
                </div>
            </div>
        @endif
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#rootEditor').summernote({
                placeholder: 'Write your argument...',
                tabsize: 2,
                height: 120,
                toolbar: [['style', ['bold', 'italic', 'underline', 'clear']]]
            });
        });

        function showFileName(input) {
            if (input.files && input.files[0]) {
                document.getElementById('file-name-display').innerText = 'Selected: ' + input.files[0].name;
            }
        }
        
        // AJAX Like and Reply Functions (Same as before)
        function voteArgument(id, type) {
            const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
            fetch(`/argument/${id}/vote`, {
                method: 'POST', headers: {'Content-Type': 'application/json', 'X-CSRF-TOKEN': token},
                body: JSON.stringify({ type: type })
            })
            .then(res => res.json())
            .then(data => {
                if(data.status === 'success'){
                    document.getElementById('like-count-'+id).innerText = data.agree_count;
                    // You can add logic to change heart color here
                } else { alert('Please login'); }
            });
        }

        function toggleReplyBox(id, type) {
            $('.reply-box').removeClass('show');
            $('#reply-box-'+id).addClass('show');
            $('#type-input-'+id).val(type);
            $('#reply-btn-'+id).text(type === 'agree' ? 'Post Agreement' : 'Post Disagreement')
                               .removeClass('btn-success btn-danger').addClass(type === 'agree' ? 'btn-success' : 'btn-danger');
            
            // Init Summernote for reply
            if (!$('#reply-box-'+id+' textarea').next().hasClass('note-editor')) {
                $('#reply-box-'+id+' textarea').summernote({height: 80, toolbar: [['font', ['bold', 'italic']]]});
            }
        }
        
        function toggleChildren(id) {
            $('#children-'+id).toggle();
        }
    </script>
</body>
</html>