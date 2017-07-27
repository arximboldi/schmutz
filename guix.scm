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

(define %source-dir (dirname (current-filename)))

(define-public schmutz
  (package
    (name "schmutz")
    (version "git")
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
