;;; init.scm -- Shepherd configuration file

(use-modules (shepherd service)
             (shepherd support)
             (ice-9 ftw))

;; Get the configuration directory path
(define config-dir
  (dirname (current-filename)))

;; Load service definitions from services directory
(load (string-append config-dir "/services/dbus.scm"))

;; Register all services
(register-services (list dbus-service))

;; Send shepherd into the background
(perform-service-action root-service 'daemonize)

;; Services to start when shepherd starts
(start-in-the-background '(dbus-session))