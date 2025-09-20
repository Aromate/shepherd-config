;;; init.scm -- Shepherd configuration file

(use-modules (shepherd service)
             (shepherd support))

;; Load service definitions from services directory
(for-each (lambda (file)
            (load (string-append "services/" file)))
          '("dbus.scm"))

;; Send shepherd into the background
(perform-service-action root-service 'daemonize)

;; Services to start when shepherd starts
(start-in-the-background '(dbus-session))