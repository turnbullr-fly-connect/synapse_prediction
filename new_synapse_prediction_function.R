#get xyz coordinates of connectors
catmaid_get_connector_table(38885) -> connector_table
connector_table[match(unique(connector_table$connector_id), connector_table$connector_id),] -> unique_connectors
data.frame(connector_id = unique_connectors$connector_id, x = unique_connectors$x, y = unique_connectors$y, z = unique_connectors$z) -> connectors_xyz

#resample a neuron to be tested to 1 um
read.neuron.catmaid(2659704) -> Duck
resample(Duck, stepsize = 1000) -> Duck_resampled
data.frame(x = Duck_resampled$d$X, y = Duck_resampled$d$Y, z = Duck_resampled$d$Z) -> Duck_xyz

points3d(xyzmatrix(connectors_xyz))
plot3d(FAFB)

#calculate distance between connectors and resampled nodes
#d(A,B) = sqrt(((x2-x1)^2)+((y2-y1)^2)+((z2-z1)^2))
distances = vector("list", length = 4140436) #Duck_xyz*connectors_xyz
counts = 0
for (i in 1:length(connectors_xyz$connector_id)){
  for (j in 1:length(Duck_xyz$x)){
    counts = counts + 1
    distances[counts] = sqrt(((connectors_xyz$x[i] - Duck_xyz$x[j])^2)+((connectors_xyz$y[i] - Duck_xyz$y[j])^2)+((connectors_xyz$z[i] - Duck_xyz$z[j])^2))
  }
}

#apply various thresholds
thresholds = c(500, 600, 700, 800, 900, 1000)
counts = vector("list", length = 6)
for (i in 1:length(thresholds)){
  counts[i] = sum(distances <= thresholds[i])
}
data.frame(threshold_nm = as.numeric(thresholds), predicted_synapses = as.numeric(counts)) -> Duck_predicted_synapses


#Phil Harris
read.neuron.catmaid(2096700) -> PH
resample(PH, stepsize = 1000) -> PH_resampled
data.frame(x = PH_resampled$d$X, y = PH_resampled$d$Y, z = PH_resampled$d$Z) -> PH_xyz

distances = vector("list", length = 1535336) #Duck_xyz*connectors_xyz
counts = 0
for (i in 1:length(connectors_xyz$connector_id)){
  for (j in 1:length(PH_xyz$x)){
    counts = counts + 1
    distances[counts] = sqrt(((connectors_xyz$x[i] - PH_xyz$x[j])^2)+((connectors_xyz$y[i] - PH_xyz$y[j])^2)+((connectors_xyz$z[i] - PH_xyz$z[j])^2))
  }
}

thresholds = c(500, 600, 700, 800, 900, 1000)
counts = vector("list", length = 6)
for (i in 1:length(thresholds)){
  counts[i] = sum(distances <= thresholds[i])
}
data.frame(threshold_nm = as.numeric(thresholds), predicted_synapses = as.numeric(counts)) -> PH_predicted_synapses


#Joffrey
read.neuron.catmaid(1376325) -> Joffrey
resample(Joffrey, stepsize = 1000) -> Joffrey_resampled
data.frame(x = Joffrey_resampled$d$X, y = Joffrey_resampled$d$Y, z = Joffrey_resampled$d$Z) -> Joffrey_xyz

distances = vector("list", length = 8336320) #Joffrey_xyz*connectors_xyz
counts = 0
for (i in 1:length(connectors_xyz$connector_id)){
  for (j in 1:length(Joffrey_xyz$x)){
    counts = counts + 1
    distances[counts] = sqrt(((connectors_xyz$x[i] - Joffrey_xyz$x[j])^2)+((connectors_xyz$y[i] - Joffrey_xyz$y[j])^2)+((connectors_xyz$z[i] - Joffrey_xyz$z[j])^2))
  }
}

thresholds = c(500, 600, 700, 800, 900, 1000)
counts = vector("list", length = 6)
for (i in 1:length(thresholds)){
  counts[i] = sum(distances <= thresholds[i])
}
data.frame(threshold_nm = as.numeric(thresholds), predicted_synapses = as.numeric(counts)) -> Joffrey_predicted_synapses
