# magpie3-causal-implicature

This repository contains several [Magpie](https://magpie-experiments.org/) experiments design to investigate "clausal implicatures", i.e., cases where interpreters infer causal information where none was explicitly conveyed.

There are several kinds of (pilot) experiments here (see `experiments` folder).
Most interesting / interpretable: 1a/b & 4.
Pilot 3 is actually interesting but has a "null result" feel to it, as all different formulations were treated the exact same.
Pilot 2 attempted iterated narration chains but failed (technical reasons, participants didn't understand what to do).

- *Pilot 1*: forced choice + justification of that forced-choice decision
  + pilots 1a and 1b differ only in the formulation of the background scenario (pilot 1b contains information that 'ralocrop' is costly to cultivate)
- *Pilot 2*: forced choice + justification + reproduction (2a only reproduction; 2b/c with actual iteration)
  + pilot 2a: similar to 1b, but with slightly rephrased instructions; also includes additional reproduction task
    - N=33, more reproduction with 'causal language' when participants chose to cultivate both crops
  + pilot 2b & c: similar to 2a, but with actual iterated narration chains; unfortunately, flawed by insufficient understanding of participants regarding what to reproduce
- *Pilot 3*: background description, choice and justification like in Pilot 1b; N = 161
  + presented three different prompts:
    1. [association]  "a high yield of xeliherb is associated with the presence of another plant called ralocrop"
    2. [intervention] "a high yield of xeliherb was observed whenever another plant called ralocrop has been cultivated as well"
    3. [observation]  "a high yield of xeliherb was observed whenever another plant called ralocrop was observed as well"
  + adds two more trials:
    - forced-choice select true statement about ralocrop
    - forced-choice select what the science team said
  + choice rates (single crop vs both) for all three prompts are indistinguishable (!?)
- *Pilot 4*: instructions like 1b, but with free reproduction of /all/ information from the background vignette
  + similar to 2a in structure, but different instructions for reproductions
  + used only the "association" vignette
  + N=50
  + hand-coded reproduction -> shows a abundance of "causal language" especially for "causal responders"
- *Pilot-indirectSource*: Method: slider rating

    + We manipulate two factors relevant to interpreting causal information: **listener type**, which includes *"colonists"* and *"scientists"*, and **information source**, which includes *"indirect"* and *"direct"*. Participants are then asked whether they perform an intervention after hearing the information, as this signals a strong causal interpretation​.

Live version of the experiment [here](https://magpie-ea.github.io/magpie3-causal-implicature/).