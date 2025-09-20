;; init.scm -- default shepherd configuration file.

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
                  "--print-pid=3"
                  "--print-address=4")
            #:environment-variables
            (cons* (string-append "DISPLAY=" (or (getenv "DISPLAY") ":0"))
                   (default-environment-variables))
            #:log-file (string-append
                        (or (getenv "XDG_RUNTIME_DIR")
                            (string-append "/run/user/" (number->string (getuid))))
                        "/dbus-session.log")
            #:pid-file-timeout 5)
   #:stop (make-kill-destructor)
   #:actions (actions
              (status
               "Show D-Bus session status"
               (lambda _
                 (let ((log-file (string-append
                                  (or (getenv "XDG_RUNTIME_DIR")
                                      (string-append "/run/user/" (number->string (getuid))))
                                  "/dbus-session.log")))
                   (if (file-exists? log-file)
                       (begin
                         (format #t "D-Bus session log file: ~a~%" log-file)
                         (format #t "Use 'cat ~a' to see the D-Bus address~%" log-file))
                       (format #t "D-Bus session log file not found~%"))))))))

;; Services known to shepherd:
;; Add new services (defined using 'service') to shepherd here by
;; providing them as a list to 'register-services'.
(register-services (list dbus-service))

;; Send shepherd into the background.
(perform-service-action root-service 'daemonize)

;; Services to start when shepherd starts:
;; Add the name of each service that should be started to the list
;; below passed to 'for-each'.
(start-in-the-background '(dbus-session))