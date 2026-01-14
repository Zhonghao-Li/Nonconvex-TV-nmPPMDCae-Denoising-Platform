# Denoising Platform – nmPPMDCae and Baseline Algorithms (Partial Code)

This repository contains **partial code** related to the **nmPPMDCae algorithm** and its **comparison experiments**.  Some of the algorithm implementations in this repository are based on or adapted from the original authors' published/open-source code.  
The corresponding sources are credited in the relevant files and comments.
We have integrated these techniques into a MATLAB-based **image denoising platform**, which allows:

- **Repeatable experiments** with fixed noise settings  
- **Systematic parameter scans** (e.g., over μ, cₖ, τ_dc, etc.)  
- **Side‑by‑side comparison** with baseline methods (FISTA, DCA, nmBDCA, etc.)

At this stage, **only non‑critical components and auxiliary scripts are included**.  
The **core implementation of nmPPMDCae and some associated methods has been intentionally removed** from this public version in order to protect the novelty of the work prior to publication.

Once the associated paper is accepted and published,  
we plan to **release the full source code**, including:

- The complete nmPPMDCae algorithm  
- All internal solver variants and advanced options  
- Full experimental scripts for reproducing all reported results
