#get xyz coordinates of connectors
catmaid_get_connector_table(38885) -> connector_table
connector_table[match(unique(connector_table$connector_id), connector_table$connector_id),] -> unique_connectors
data.frame(connector_id = unique_connectors$connector_id, x = unique_connectors$x, y = unique_connectors$y, z = unique_connectors$z) -> connectors_xyz

#resample a neuron to be tested to 1 um
read.neuron.catmaid(2659704) -> Duck
resample(Duck, stepsize = 1000) -> Duck_1um
resample(Duck, stepsize = 500) -> Duck_0.5um
resample(Duck, stepsize = 100) -> Duck_0.1um

data.frame(x = Duck_1um$d$X, y = Duck_1um$d$Y, z = Duck_1um$d$Z) -> Duck_1um_xyz
data.frame(x = Duck_0.5um$d$X, y = Duck_0.5um$d$Y, z = Duck_0.5um$d$Z) -> Duck_0.5um_xyz
data.frame(x = Duck_0.1um$d$X, y = Duck_0.1um$d$Y, z = Duck_0.1um$d$Z) -> Duck_0.1um_xyz

#calculate distance between connectors and resampled nodes
#d(A,B) = sqrt(((x2-x1)^2)+((y2-y1)^2)+((z2-z1)^2))

#1um
distances = vector("list", length = 4140436) #Duck_1um_xyz*connectors_xyz
counts = 0
for (i in 1:length(connectors_xyz$connector_id)){
  for (j in 1:length(Duck_1um_xyz$x)){
    counts = counts + 1
    distances[counts] = sqrt(((connectors_xyz$x[i] - Duck_1um_xyz$x[j])^2)+((connectors_xyz$y[i] - Duck_1um_xyz$y[j])^2)+((connectors_xyz$z[i] - Duck_1um_xyz$z[j])^2))
  }
}

thresholds = c(500, 600, 700, 800, 900, 1000)
counts = vector("list", length = 6)
for (i in 1:length(thresholds)){
  counts[i] = sum(distances <= thresholds[i])
}
data.frame(threshold_nm = as.numeric(thresholds), predicted_synapses = as.numeric(counts)) -> Duck_1um_predicted_synapses

#0.5um
distances = vector("list", length = 4028106) #Duck_0.5um_xyz*connectors_xyz
counts = 0
for (i in 1:length(connectors_xyz$connector_id)){
  for (j in 1:length(Duck_0.5um_xyz$x)){
    counts = counts + 1
    distances[counts] = sqrt(((connectors_xyz$x[i] - Duck_0.5um_xyz$x[j])^2)+((connectors_xyz$y[i] - Duck_0.5um_xyz$y[j])^2)+((connectors_xyz$z[i] - Duck_0.5um_xyz$z[j])^2))
  }
}

thresholds = c(500, 600, 700, 800, 900, 1000)
counts = vector("list", length = 6)
for (i in 1:length(thresholds)){
  counts[i] = sum(distances <= thresholds[i])
}
data.frame(threshold_nm = as.numeric(thresholds), predicted_synapses = as.numeric(counts)) -> Duck_0.5um_predicted_synapses

#0.1um
distances = vector("list", length = 13946606) #Duck_0.1um_xyz*connectors_xyz
counts = 0
for (i in 1:length(connectors_xyz$connector_id)){
  for (j in 1:length(Duck_0.1um_xyz$x)){
    counts = counts + 1
    distances[counts] = sqrt(((connectors_xyz$x[i] - Duck_0.1um_xyz$x[j])^2)+((connectors_xyz$y[i] - Duck_0.1um_xyz$y[j])^2)+((connectors_xyz$z[i] - Duck_0.1um_xyz$z[j])^2))
  }
}

thresholds = c(500, 600, 700, 800, 900, 1000)
counts = vector("list", length = 6)
for (i in 1:length(thresholds)){
  counts[i] = sum(distances <= thresholds[i])
}
data.frame(threshold_nm = as.numeric(thresholds), predicted_synapses = as.numeric(counts)) -> Duck_0.1um_predicted_synapses
