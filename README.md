# BME772_SignalAnalysis

This repositories hosts labs I completed as part of Biomedical Signal Analysis course in the department of Biomedical Engineering at Ryerson University.

Lab 1: Synchronized Averaging - This lab uses synchronized averaging to reduce the noise present in repetitive signals.  This works as signals follow the same patterns and high frequency noise is reduced.

Lab 2: ECG Filtering and Noise Removal - This lab required the design and application of digital filters to remove noise typically present in an ECG signal. Filters explored were notch, hanning window and derivative filters, on their own and combined.

Lab 3: Pan Tompkins Algorithm - The Pan Tompkins algorithm is designed for the detection of QRS complex (heart beats) from ECGs.  These are identified based of the slope, amplitude and width at various filters. A bandpass filter removes EMG (Muscle) noise, powerline interference noise and baseline drift.  A derivative filter captures the slope and then a squaring operation will amplify the higher output values and suppress the lower ones. The final step is the smoothing out via a moving average window filter.  From here the QRS complexes are identified and from the R-R interval heartbeats can be analyzed.  This identification and heart beat calculation provides biometrics that physicians can use to detect abnormalities.

Lab 4: Speech Analysis - In this lab we were tasked with the challenge of identifying formants, pitch, voiced and unvoiced components.  This is accomplished using autocorrelation.  Analysis was then done to detect various peaks and identifying characteristics of typical sounds produced by individuals.
