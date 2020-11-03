(in-package :cl-user)
(defpackage :chapter-2-1
  (:use :cl))
(in-package :chapter-2-1)

(defvar *csgo-launched-p* nil)
(defvar *hooks* '())

(defvar *phonebook*
  '((:mom :parent)
    (:dad :parent)
    (:alice :classmate :csgo :homework)
    (:bob :classmate :homework)
    (:catherine :classmate :ex)
    (:dorothy :classmate :girlfriend :csgo)
    (:eric :classmate :homework)
    (:dentist)))


(defun call-hooks (kind &rest arguments)
  (dolist (hook *hooks*)
    (destructuring-bind (hook-kind hook-function) hook
      (when (eq kind hook-kind)
        (apply hook-function arguments)))))

(defun call-person (person)
  (format t ";; Calling ~A.~%" (first person)))

(defun call-people ()
  (setf *csgo-launched-p* nil)
  (dolist (person *phonebook*)
    (catch :do-not-call
      (call-hooks 'before-call person)
      (call-person person)
      (call-hooks 'after-call person))))

(defun ensure-csgo-launched (person)
  (when (member :csgo person)
    (unless *csgo-launched-p*
      (format t ";; Launging Counter Strike for ~A~%" (first person))
      (setf *csgo-launched-p* t))))

(defun skip-non-csgo-people (person)
  (unless (member :csgo person)
    (format t ";; Nope, not calling ~A.~%" (first person))
    (throw :do-not-call nil)))

(defun maybe-call-parent (person)
  (when (member :parent person)
    (when (zerop (random 2))
      (format t ";; Nah, not calling ~A, this time.~%" (first person))
      (throw :do-not-call nil))))

(defun skip-non-parents (person)
  (unless (member :parent person)
    (throw :do-not-call nil)))

(defun skip-ex (person)
  (when (member :ex person)
    (format t ";; Nah, not calling ex: ~A.~%" (first person))
    (throw :do-not-call nil)))

(defun wish-happy-holidays (person)
  (format t ";; Wish ~A happy holidays.~%" (first person)))

(defun call-girlfriend-again (person)
  (when (member :girlfriend person)
    (format t ";; Calling girlfriend ~A again.~%" (first person))
    (call-person person)))

(let ((*hooks* `((before-call ,#'ensure-csgo-launched)
                 (after-call ,#'call-girlfriend-again))))
  (call-people))

(let ((*hooks* `((before-call ,#'skip-ex)
                 (before-call ,#'ensure-csgo-launched)
                 (before-call ,#'wish-happy-holidays)
                 (after-call ,#'call-girlfriend-again))))
  (call-people))
