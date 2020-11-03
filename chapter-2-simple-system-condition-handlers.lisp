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
    (signal 'before-call :person person)
    (call-person person)))

(handler-bind
    ((before-call
       (lambda (condition)
         (let ((person (person condition)))
           (when (member :csgo person)
             (unless *csgo-launched-p*
               (format t ";; Launching Counter String for ~A.~%" (first person))
               (setf *csgo-launched-p* t)))))))
  (call-people))
