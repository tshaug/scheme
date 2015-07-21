;;; Joy of Scheme Revival Project
;;; Thomas Haug
;;; Copyright 2015
;;; thomas.haug@mathema.de 

;;; a mulithreaded TCP Server

;; import the socket lib
(import (rnrs)
		(tshaug sockets)
        (ironscheme threading))

(define (id-server port)
   (let ((listener (create-tcp-listener port)))
      (begin  
         (show-welcome-message port) 
         (start-tcp-listener listener)
         (start-thread (make-thread (lambda () (echo-client listener))))
         (shutdown-server listener)
      )
   ) ; let
) ; define


(define (echo-client listener)
   (let ((tcp-client (accept-tcp-listener listener)))
         (begin
           (start-thread (make-thread (lambda () (handle-tcp-client tcp-client))))
           (echo-client  listener)
         )
   )
)

(define (handle-tcp-client tcp-client)
   (let* ((network-stream (get-network-stream tcp-client)) ;; blocking call!
			    (in-out-streams (get-streams network-stream))
			    (in-stream (car in-out-streams))
          (out-stream (cdr in-out-streams))
          (input (get-line in-stream))
			   )
         (begin
            (newline)
		        (display "Received: ")
            (display input)
            (newline)
            (display "sleeping for 10 seconds ...")
            (thread-sleep 10000)
            (display (string-append "Hello " input ", Scheme Server is speaking") out-stream)
            (newline out-stream)
            (flush-output-port out-stream)
        
            (close-input-port in-stream) 
            (close-output-port out-stream)
                  
         ) 
   )
)

(define (show-welcome-message port)
   (display "Multithreaded Server v0.1")
   (newline)
   (display "Waiting on port ")
   (display port)
   (newline)
)

(define (shutdown-server listener)
   (begin
      (display "press 'return-key' to stop the server")
      (get-line (current-input-port))  
      (stop-tcp-listener listener)
   )
) 

(id-server 9998)