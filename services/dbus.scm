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
                  "--print-address"
                  "--address"
                  (string-append "unix:path=/var/run/user/"
                                 (number->string (getuid))
                                 "/dbus.socket,guid=4cea9d8ac254df38a80092ed68ce6fdb"))
            #:environment-variables
            (cons* (string-append "DISPLAY=" (or (getenv "DISPLAY") ":0"))
                   (default-environment-variables))
            #:log-file (string-append
                        (or (getenv "XDG_RUNTIME_DIR")
                            (string-append "/run/user/" (number->string (getuid))))
                        "/shepherd/dbus.log"))
   #:stop (make-kill-destructor)))