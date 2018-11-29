#synapse prediction using existing functions

#connectors
#rdist
#xyzmatrix

read.neuron.catmaid(38885) -> DA2
read.neuron.catmaid(2659704) -> Duck
resample(Duck, stepsize = 1000) -> Duck_resampled

connectors(DA2) -> DA2_connectors
xyzmatrix(DA2_connectors) -> DA2_xyz   #DA2 connectors as xyz matrix
xyzmatrix(Duck_resampled) -> Duck_xyz   #Resampled Duck nodes as xyz matrix

rdist(DA2_xyz, Duck_xyz) -> distances   #Distance matrix between DA2 connectors and Duck nodes
which(distances <= 740, arr.ind = TRUE) -> synapses   #Distances below a threshold (i.e. potential synapses)
as.data.frame(synapses) -> synapses
synapses[match(unique(synapses$row), synapses$row),] -> synapses_unique_connectors  #Each connector should only be able to contact a skeleton once, otherwise it overestimates

as.numeric(synapses_unique_connectors$row) -> connectors
DA2_xyz[connectors,] -> connectors_xyz  #get xyz for each connector

#set up 3d environment
nopen3d()
op <- structure(list(FOV = 30, userMatrix = structure(c(0.998838663101196,  #code Kimberly made to resize rgl window
                                                        -0.00085014256183058, 0.0481719076633453, 0, 0.00598131213337183, 
                                                        -0.989921271800995, -0.141492277383804, 0, 0.0478066727519035, 
                                                        0.141615957021713, -0.988766610622406, 0, 0, 0, 0, 1),
                                                      .Dim = c(4L, 4L)), scale = c(1, 1, 1), zoom = 0.545811593532562, 
                     windowRect = c(4L,45L, 780L, 620L)),
                .Names = c("FOV", "userMatrix", "scale", "zoom", "windowRect"))
par3d(op)

#reset environment
clear3d()

plot3d(FAFB14.surf, col = "white", alpha = 0.2)
plot3d(DA2, soma = TRUE, col = "blue")
points3d(connectors_xyz, col = 'red')

