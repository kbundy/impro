;+
; NAME:
;   WRITE_SUPERGRID_PARAMFILE()
;
; PURPOSE:
;   Initialize the supergrid parameter file for iSEDfit.
;
; INPUTS: 
;
; OPTIONAL INPUTS: 
;
; KEYWORD PARAMETERS:
;   clobber - overwrite existing parameter file
; 
; OUTPUTS: 
;   This code writes a parameter file called SUPERGRID_PARAMFILE.par
; 
; COMMENTS:
;
; MODIFICATION HISTORY:
;   J. Moustakas, 2013 Jan 12, Siena
;
; Copyright (C) 2013, John Moustakas
; 
; This program is free software; you can redistribute it and/or modify 
; it under the terms of the GNU General Public License as published by 
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version. 
; 
; This program is distributed in the hope that it will be useful, but 
; WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
; General Public License for more details. 
;-

function init_supergrid, nsuper
; assign default no-burst parameters
    params = {$
      supergrid:         1L,$
      sfhgrid:           1L,$
      imf:           'chab',$
      synthmodels:   'fsps',$
      redcurve:           1} ; Charlot & Fall
return, replicate(params,nsuper)
end    

pro write_supergrid_paramfile, supergrid_paramfile, supergrid=supergrid, $
  sfhgrid=sfhgrid, imf=imf, synthmodels=synthmodels, redcurve=redcurve

    nsuper = n_elements(supergrid)
    if n_elements(supergrid_paramfile) eq 0 or nsuper eq 0 then begin
       doc_library, 'write_supergrid_paramfile'
       return
    endif
    
; initialize the parameter structure
    params = init_supergrid(nsuper)
    params.supergrid = supergrid

    nsfh = n_elements(sfhgrid)
    if nsfh ne 0 then begin
       if nsfh ne 1 and nsfh ne nsuper then message, 'SFHGRID must '+$
         'be a scalar or match the number of elements in SUPERGRID'
       
       
    endif
    
; override any of the free parameters    
    if n_elements(nage) ne 0 then params.nage = nage
    
    if im_file_test(supergrid_paramfile,clobber=clobber) then return

; write out
    hdr = [['# iSEDfit SUPERGRID parameters'],$
      ['# Generated by WRITE_SUPERGRID_PARAMFILE on '+im_today()]]
    splog, 'Writing '+supergrid_paramfile
    yanny_write, supergrid_paramfile, ptr_new(params), $
      stnames='SUPERGRIDPARAMS', /align, hdr=hdr

return
end