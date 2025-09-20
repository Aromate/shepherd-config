;;; dbus.scm -- D-Bus session bus service definition

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
                  "--print-pid=3"
                  "--print-address=4")
            #:environment-variables
            (cons* (string-append "DISPLAY=" (or (getenv "DISPLAY") ":0"))
                   (default-environment-variables))
            #:log-file (string-append
                        (or (getenv "XDG_RUNTIME_DIR")
                            (string-append "/run/user/" (number->string (getuid))))
                        "/shepherd/dbus.log")
            #:pid-file-timeout 5)
   #:stop (make-kill-destructor)))

;; Register the service
(register-services (list dbus-service))