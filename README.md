# synapse_prediction
Development of a function to predict the number of synapses between two neurons in the FAFB dataset

## How does it work?
In principle, synapses may occur through the close apposition of a presynaptic connector and a neuron skeleton. This function measures the distance between each presynapic connector on a candidate neuron and every skeleton node on a target downstream neuron, comparing it to a given threshold.

The downstream targets of one of the DA2 PNz (SKID: 38885) will be used as the test dataset, whose connectivity is well-established.

## Development and testing
1. Establish basic workflow
2. Change sampling of downstream targets
3. Prune downstream targets in various ways
4. Compare with ```potential_synapses()``` from Alex Bates
5. Write into a user-friendly function
