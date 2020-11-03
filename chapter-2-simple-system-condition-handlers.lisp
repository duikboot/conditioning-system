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
    (call-person person)))
