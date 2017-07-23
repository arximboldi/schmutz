(define-module (arximboldi packages schmutz)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages version-control))

(define-public schmutz
  (let ((commit "1a0e716e330356dd138e918f7ae91e70369282cd"))
    (package
      (name "schmutz")
      (version (string-append "0.0.0-git-" (string-take commit 9)))
      (synopsis "Bind C++ code to Scheme")
      (description "Bind C++ code to Scheme")
      (home-page "https://github.com/arximboldi/schmutz")
      (license boost1.0)
      (build-system cmake-build-system)
      (arguments `(#:tests? #f))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/arximboldi/schmutz.git")
               (commit commit)))
         (file-name (string-append "immer-" version "-checkout"))
         (sha256
          (base32 "0c4wdd6365nkl1fynycvs5qgmrmr8x3ipsl18m6znjbmbxwnx3vq"))))
      (native-inputs
       `(("pkg-config" ,pkg-config)
         ("git" ,git)))
      (inputs
       `(("guile" ,guile-2.2))))))

schmutz
