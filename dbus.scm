;;; dbus.scm -- D-Bus session bus service for Shepherd

(define-module (dbus)
  #:use-module (shepherd service)
  #:use-module (shepherd support)
  #:export (dbus-service))

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
            (cons* "DISPLAY=:0"
                   (environ))
            #:log-file (string-append
                        (or (getenv "XDG_RUNTIME_DIR")
                            (string-append "/run/user/" (number->string (getuid))))
                        "/dbus-session.log"))
   #:stop (make-kill-destructor)
   #:actions (actions
              (status
               "Show D-Bus session status"
               (lambda _
                 (let ((addr (getenv "DBUS_SESSION_BUS_ADDRESS")))
                   (if addr
                       (format #t "D-Bus session bus address: ~a~%" addr)
                       (format #t "D-Bus session bus address not set~%"))))))))

(register-services (list dbus-service))

(provide 'dbus)