(in-package :cl-user)
(defpackage :chapter-2
  (:use :cl))
(in-package :chapter-2)

(defvar *csgo-launched-p* nil)
(defvar *before-hooks* nil)
(defvar *after-hooks* nil)

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
    (catch :do-not-call
      (dolist (hook *before-hooks*)
        (funcall hook person))
      (call-person person)
      (dolist (hook *after-hooks*)
        (funcall hook person)))))

(defun ensure-csgo-launched (person)
  (when (member :csgo person)
    (unless *csgo-launched-p*
      (format t ";; Launging Counter Strike for ~A" (first person))
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

;;; Only csgo
(let ((*before-hooks* (list #'ensure-csgo-launched
                            #'skip-non-csgo-people)))
  (call-people))

;;; Parents
(let ((*before-hooks* (list #'maybe-call-parent
                            #'skip-non-parents)))
  (call-people))

;;; Holiday wishes
(let ((*before-hooks* (list #'skip-ex
                            #'wish-happy-holidays)))
  (call-people))

;;; Call girlfriend again
(let ((*after-hooks* (list #'call-girlfriend-again)))
  (call-people))


;;; Before and after hooks
(let ((*before-hooks* (list #'ensure-csgo-launched
                            #'skip-non-csgo-people))
      (*after-hooks* (list #'call-girlfriend-again)))
  (call-people))
