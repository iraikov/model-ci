#! /home/igr/bin/chicken/bin/csi -script

(use srfi-1 posix ploticus)

(define (plot-traces model-name title trace-names nrows octave-build-dir neuron-build-dir)

    (init 'png (sprintf "~A.png" model-name))

    (arg "-cpulimit" "90" )

    (arg "-cm" )
    (arg "-pagesize"    "30,24")
    (arg "-maxrows"     "5200500")
    (arg "-maxfields"   "10400100")
    (arg "-maxvector"   "20000000")
    (arg "-font"        "FreeSans")
    (arg "-textsize"    "14")

    (proc "page"
          `(("title"            . ,title)
            ))

    (fold
     (lambda (trace-name ij)

       (let ((trace-file-octave (make-pathname octave-build-dir (sprintf "~A.dat" trace-name)))
             (trace-file-neuron (make-pathname neuron-build-dir (sprintf "~A.dat" trace-name)))
             (i (car ij)) (j (cadr ij)))

         (proc "getdata"
               `(("file"            . ,trace-file-octave)
                 ("fieldnames"      . "time I")
                 ))

         (printf "~A getdata finished " trace-name)

         (proc "areadef"
               `(("title"           . ,trace-name)
                 ("titledetails"    . "size=14  align=C")
                 ("rectangle"       . ,(let* ((x1 (+ 2 (* 6 i)))
                                              (x2 (+ 4 x1))
                                              (y1 (+ 3 (* 5 j)))
                                              (y2 (+ 3 y1)))
                                         (printf "(coordinates ~A ~A ~A ~A)~%" x1 y1 x2 y2)
                                         (sprintf "~A ~A ~A ~A" x1 y1 x2 y2)))
                 ("xautorange"      . "datafield=time")
                 ("yautorange"      . "datafield=I")
                 ))

         (proc "yaxis"
               `(("stubs"     . "inc")
                 ("gridskip"  . "min")
                 ))

         (proc "xaxis"
               `(("stubs"     . "inc 200")
                 ("gridskip"  . "min")
                 ))

         (proc "lineplot"
               `(("xfield"      . "time")
                 ("yfield"      . "I")
                 ("linedetails" . "color=red width=.7")
                 ))
   
         (proc "legend"
               `(("location" . "max-1 max")
                 ("seglen"   . "0.2")
                 ))

         (proc "getdata"
               `(("file"            . ,trace-file-neuron)
                 ("fieldnames"      . "time I")
                 ))
         
         (proc "lineplot"
               `(("xfield"      . "time")
                 ("yfield"      . "I")
                 ("linedetails" . "color=blue width=.7")
                 ))
         
         (if (< i (- nrows 1))
             (list (+ 1 i) j)
             (list 0 (+ 1 j)))

         )
       )

     (list 0 0)
     trace-names)

    (end)
    )


(let ((args (command-line-arguments)))

  (let (
	(model-name (first args))
	(octave-build-dir (second args))
	(neuron-build-dir (third args))
	)	   

    (if (not (get-environment-variable "GDFONTPATH"))
        (setenv "GDFONTPATH" "/usr/share/fonts/truetype/freefont"))
            
    (plot-traces model-name
                 "CA1 Royeck 2008 voltage clamp\n (Octave + NEURON)" 
                '(
                  CaL CaR CaNPQ CaT KM KaG KCT_ca Na NaP NaIn  )
                3 octave-build-dir neuron-build-dir)

    ))
