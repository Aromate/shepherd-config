;; init-new.scm -- shepherd configuration with D-Bus service

(use-modules (shepherd service)
             (shepherd support))

;; Define D-Bus session service
(define dbus-service
  (service
   '(dbus-session)
   #:documentation "D-Bus session message bus"
   #:requirement '()
   #:respawn? #t
   #:start (make-forkexec-constructor
            (list "dbus-daemon"
                  "--session"
                  "--nofork"
                  "--nopidfile"
                  "--print-address=1")
            #:environment-variables
            (cons "DISPLAY=:0"
                  (default-environment-variables))
            #:log-file (string-append
                        (or (getenv "XDG_RUNTIME_DIR")
                            (string-append "/run/user/" (number->string (getuid))))
                        "/dbus-session.log"))
   #:stop (make-kill-destructor)))

;; Register services
(register-services (list dbus-service))

;; Send shepherd into the background
(perform-service-action root-service 'daemonize)

;; Services to start when shepherd starts
(start-in-the-background '(dbus-session))