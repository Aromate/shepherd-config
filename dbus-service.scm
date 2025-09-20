;;; dbus-service.scm -- D-Bus session bus service for Shepherd

(use-modules (shepherd service)
             (shepherd support))

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