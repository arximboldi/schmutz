(define-module (arximboldi packages schmutz)
  #:use-module (rnrs io ports)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 rdelim)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages version-control))

(define (read-command cmd)
  (let* ((port (open-input-pipe cmd))
         (str  (read-line port)))
    (close-pipe port)
    (if (eof-object? str) "" str)))

(define %git-commit  (read-command "git rev-parse HEAD"))
(define %git-status  (read-command "git status --porcelain"))
(define %git-version (string-append "git-"
                                    %git-commit
                                    (if (string-null? %git-status)
                                        "" "-dirty")))
(define %source-dir  (dirname (current-filename)))

(define-public schmutz
  (package
    (name "schmutz")
    (version %git-version)
    (synopsis "Bind C++ code to Scheme")
    (description "Bind C++ code to Scheme")
    (home-page "https://github.com/arximboldi/schmutz")
    (license boost1.0)
    (build-system cmake-build-system)
    (arguments `(#:tests? #f))
    (source (local-file %source-dir
                        #:recursive? #t
                        #:select? (git-predicate %source-dir)))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("git" ,git)))
    (inputs
     `(("guile" ,guile-2.2)))))

schmutz
