;;; Joy of Scheme Revival Project
;;; Thomas Haug
;;; Copyright 2015
;;; thomas.haug@mathema.de 

;;; a "looping" TCP Server

;; import the socket lib
(import (rnrs)
		(tshaug sockets))

(define (id-server port)
   (let ((listener (create-tcp-listener port)))
      (begin  
         (show-welcome-message port) 
         (start-tcp-listener listener)
         (echo-client listener)
         (stop-tcp-listener listener)
      )
   ) ; let
) ; define


(define (echo-client listener)
   (let loop ((tcp-client (accept-tcp-listener listener)))
         (begin
           (handle-tcp-client tcp-client)
           (loop (accept-tcp-listener listener))
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
		        (display "Received: ")
            (display input)
            (newline)
            (display (string-append "Hello " input ", Scheme Server is speaking") out-stream)
            (newline out-stream)
            (flush-output-port out-stream)
        
            (close-input-port in-stream) 
            (close-output-port out-stream)
                  
         ) 
   )
)

(define (show-welcome-message port)
   (display "\"Looping\" Server")
   (newline)
   (display "Waiting on port ")
   (display port)
   (newline)
)

(id-server 9998)