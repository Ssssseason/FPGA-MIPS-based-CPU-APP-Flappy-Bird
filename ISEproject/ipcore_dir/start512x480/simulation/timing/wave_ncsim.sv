
 
 
 

 



window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"


      waveform add -signals /start512x480_tb/status
      waveform add -signals /start512x480_tb/start512x480_synth_inst/bmg_port/CLKA
      waveform add -signals /start512x480_tb/start512x480_synth_inst/bmg_port/ADDRA
      waveform add -signals /start512x480_tb/start512x480_synth_inst/bmg_port/DOUTA
console submit -using simulator -wait no "run"
