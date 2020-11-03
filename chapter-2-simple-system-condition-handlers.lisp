(in-package :cl-user)
(defpackage :chapter-2-simple-system-condition-helpers
  (:use :cl))
(in-package :chapter-2-simple-system-condition-helpers)

(defvar *csgo-launched-p* nil)

(defvar *phonebook*
  '((:mom :parent)
    (:dad :parent)
    (:alice :classmate :csgo :homework)
    (:bob :classmate :homework)
    (:catherine :classmate :ex)
    (:dorothy :classmate :girlfriend :csgo)
    (:eric :classmate :homework)
    (:dentist)))

(define-condition before-call ()
  ((%person :reader person :initarg :person)))

(defun call-person (person)
  (format t ";; Calling ~A.~%" (first person)))

(defun call-people ()
  (setf *csgo-launched-p* nil)
  (dolist (person *phonebook*)
    (catch :do-not-call
      (signal 'before-call :person person)
      (call-person person))))

(defun ensure-csgo-launched (condition)
  (let ((person (person condition)))
    (when (member :csgo person)
      (unless *csgo-launched-p*
        (format t ";; Launching Counter Strike for ~A.~%" (first person))
        (setf *csgo-launched-p* t)))))

(defun skip-non-csgo-people (condition)
  (let ((person (person condition)))
    (unless (member :csgo person)
      (format t ";; Nope, not calling ~A.~%" (first person))
      (throw :do-not-call nil))))

(defun no-ex (condition)
  (let ((person (person condition)))
    (when (member :ex person)
      (format t ";; Dont call ex ~A.~%" (first person))
      (throw :do-not-call nil))))

(defun maybe-call-parent (condition)
  (let ((person (person condition)))
    (when (member :parent person)
      (when (zerop (random 2))
        (format t ";; Nah, not calling ~A, this time.~%" (first person))
        (throw :do-not-call nil)))))

(defun skip-non-parents (condition)
  (let ((person (person condition)))
    (unless (member :parent person)
      (throw :do-not-call nil))))


(handler-bind ((before-call #'ensure-csgo-launched)
               (before-call #'skip-non-csgo-people))
  (call-people))

(handler-bind ((before-call #'maybe-call-parent)
               (before-call #'skip-non-parents))
  (call-people))
