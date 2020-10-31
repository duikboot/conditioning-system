(in-package :cl-user)
(defpackage :chapter-2
  (:use :cl))
(in-package :chapter-2)

(defvar *csgo-launched-p* nil)
(defvar *hooks* nil)

(defvar *phonebook*
  '((:mom :parent)
    (:dad :parent)
    (:alice :classmate :csgo :homework)
    (:bob :classmate :homework)
    (:catherine :classmate :ex)
    (:dorothy :classmate :girlfriend :csgo)
    (:eric :classmate :homework)
    (:dentist)))

(defun call-person (person)
  (format t ";; Calling ~A.~%" (first person)))

(defun call-people ()
  (setf *csgo-launched-p* nil)
  (dolist (person *phonebook*)
    (dolist (hook *hooks*)
      (funcall hook person))
    (call-person person)))

(defun ensure-csgo-launched (person)
  (when (member :csgo person)
    (unless *csgo-launched-p*
      (format t ";; Launging Counter Strike for ~A" (first person))
      (setf *csgo-launched-p* t))))

(let ((*hooks* (list #'ensure-csgo-launched)))
  (call-people))
