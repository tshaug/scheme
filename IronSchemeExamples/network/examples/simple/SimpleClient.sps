;;; Joy of Scheme Revival Project 
;;; Thomas Haug
;;; Copyright 2015
;;; thomas.haug@mathema.de 

;;; a simple TCP client

;; import the socket lib
(import (rnrs)
		(tshaug sockets))

(define tcpclient (create-tcp-client "localhost" 9998))
(define network-stream (get-network-stream tcpclient)) 
(define in-out-streams (get-streams network-stream))
(define in-stream (car in-out-streams))

(let ((out (cdr in-out-streams)))
     (begin 
        (write 'Ernie out)
        (newline out)
        (flush-output-port out)
	 )
)
(display (get-line  in-stream))
(newline)