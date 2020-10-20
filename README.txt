CeSnAP (C. elegans Snapshot Analysis Platform)

We have created a ML-based algorithm, CeSnAP, paired with a rapid snapshot acquisition technique
that serves as a simple and versatile workflow to quantify C. elegans behavioral phenotypes [1].
CeSnAP can be used for smart analysis of videos or snapshots upon training of a convolutional
neural network (C-NN). The program maintains low data overhead, eliminates the need for user
supervision, and can be utilized by investigators with no computational background, greatly
accelerating efforts to perform high-throughput screens. 

Using CeSnAP, we performed high-throughput curling analysis of a total of 17,000 worms in order
to identify drugs that ameliorate PD-like motor dysfunction in C. elegans. Our high-throughput
automated curling assay can record, process, and analyze experimental data 40 times faster than
the manual thrashing assay, and has allowed for high-throughput drug screening [1] and testing
of disease mechanisms [2, 3]. The demo examples are available on 
https://murphylab.princeton.edu/CeSnAP/.

CeSnAP uses Bio-Formats MATLAB scripts for reading *.nd2 files. User can download Bio-Formats 
from following link: https://docs.openmicroscopy.org/bio-formats/5.3.4/users/matlab/index.html.
please add "bioformats_package.jar" to bfmatlab folder for reading .*ND2 files.

References

[1] Sohrabi, S., Mor, D. E., Kaletsky, R., Keyes, W., & Murphy, C. T. (2020). 
    High-throughput behavioral screen in C. elegans reveals novel Parkinson disease drug candidates. bioRxiv.

[2] Mor, D. E., Sohrabi, S., Kaletsky, R., Keyes, W., Tartici, A., Kalia, V., ... & Murphy, C. T. (2020). 
    Metformin rescues Parkinson’s disease phenotypes caused by hyperactive mitochondria. Proceedings of the National Academy of Sciences.

[3] Yao & Kaletsky, Keyes, W., Mor, D. E., Wong, A. K., Sohrabi, S., Murphy, C. T., & Troyanskaya, O. G. (2018). 
    An integrative tissue-network approach to identify and test human disease genes. Nature Biotechnology, 36(11), 1091. 
