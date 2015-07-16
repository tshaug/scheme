;;; Joy of Scheme Revival Project 
;;; Thomas Haug
;;; Copyright 2015
;;; thomas.haug@mathema.de 

(library (tshaug sockets)
  (export
    create-tcp-client
    create-tcp-listener 
    start-tcp-listener
    stop-tcp-listener
	  accept-tcp-listener
	  get-network-stream
	  get-streams
	
    ;; eigentlich nicht Bestandteil sondern sollte in eigener lib liegen
    read-in-stream-as-string
    )
  
	(import 
	(rnrs)
	(ironscheme clr))

	(clr-using System.IO)
	(clr-using System.Net)
	(clr-using System.Net.Sockets)


	;; create a new client socket
	(define (create-tcp-client ip port)
		(if (and (number? port) (string? ip))
		  (clr-new TcpClient ip port)
		  (error create-tcp-client "provided ip and/or port are wrong" ip port)
		)
	)
	
	(define (create-tcp-listener port)
		(if (number? port)
		  (clr-new TcpListener (clr-static-field-get IPAddress Any) port)
		  (error create-tcp-listener"not a port number:" port)
		)
	)
	
	(define (start-tcp-listener listener)
		(if (clr-is TcpListener listener)
		  (clr-call TcpListener Start listener)
		  (error start-tcp-listener "not a TcpListener" listener)
		)
	  )


	(define (stop-tcp-listener listener)
		(if (clr-is TcpListener listener)
		  (clr-call TcpListener Stop listener)
		  (error stop-tcp-listener "Provided parameter is not a TcpListener" listener)
		)
	)

	;;; returns a TcpClient object
	(define (accept-tcp-listener listener)
		(if (clr-is TcpListener listener)
		  (clr-call TcpListener AcceptTcpClient listener)
		  (error accept-tcp-listener "parameter is not a TcpListener" listener)
		  )
	)
	
	(define (get-network-stream tcpClient)
	   (if (clr-is TcpClient tcpClient)
		  (clr-call TcpClient GetStream tcpClient)
		  (error get-network-stream "Provided parameter is not a TcpClient" tcpClient)
	   )
	)

	;; this procedure returns two stream objects as a pair
	;; 
	(define (get-streams stream)
	   (if (clr-is NetworkStream stream)
		  (cons
			 (clr-new StreamReader stream)
			 (clr-new StreamWriter stream)
		  )
		 (error get-streams "provided parameter is not a NetworkStream" stream)
	   )
	)

  ;; read string from input stream until EOF is reached
  (define (read-in-stream-as-string instream)
    (let loop ((input (read-char instream))
                (result (make-string 0)))
           (if (eof-object? input)
                  result
               (loop (read-char instream) (string-append result (string input)))
           ); if 
     ) ; let	
  )
)
