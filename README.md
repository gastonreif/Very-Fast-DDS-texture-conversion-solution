# Very-Fast-DDS-texture-conversion-solution
convert satellite imaginary JPG files to DDS format using CUDA or CPU in batch and very fast
Very Fast DDS texture conversion solution v2.5rc1
can be used for Forkboy2s Orthophoto projects

Features
- High Performance scripts for parallel computing
- four batch scripts, CPU powered conversion and CPU+GPU powered parallel conversions
- adjustable CPU/GPU ratio for best performance. Speedup upto 50%
- uses current technologies from Microsoft Direct X
- on fast machines 1 texture is converted way less under 1 second
- on slower machines 1 texture is converted under 3 seconds
- supports multithreading (uses all available cores of CPU)
- CUDA processing on supported nvidia chipsets
- supports most of the used picture formats
- many options for quality and performance
- built in feature for deleting unwanted files
- estimates disk space for conversion
- progress bar
- reports not converted files by their names in case of errors, bad data etc.
- elapsed time

Description
Texture conversion batch files for DirectXTex library/utility from Chuck Walbourn an Microsoft Engineer and his team.
Its significaly faster than nvidia nvcompress from 2007 Texture tools bundle by CPU processing.
However there is choice to use High performance parallel conversions using CUDA from nvidia along with CPU conversion.
Recommended for all who is creating or using Orthophoto sceneries, it saves time and space.

Performance
For best performance and speed gain (upto 50%) use CPU+GPU Powered scripts _HPC_CUDA.cmd or MPC_CUDA.cmd .
Using this HPC script four computing CUDA nodes on nvidia chipsets driven by nvcompress CUDA enabled will
run parallel with CPU driven by texconv. Nvcompress using only 1-2 threads from CPU to instructs the job.
You can adjust distribution load for CPU or GPU by ratio. Recommended is 50:50 and may vary from PC to PC.
Enter percentage of files to be processed by GPU.
Find your best ratio. If CPU conversion is done before GPU (or GPU is done before CPU finishes)
you should nextime adjust the ratio. Ideal is CPU and GPU conversion ends at the same time. See results on screen.
Converts texture by CPU or by CPU/GPU under 1 second on latest multicore CPUs
Converts texture under 3 seconds even on older computers
Dont need to wait overnight for conversion of famous Forkboy2s US Orthophotos scenery packs
If its run slow make sure no other processes is affecting perfomance and check CPU affinity for texconv.exe,
should be selected for all CPU cores (use ProcessLasso for it for example) or adjust CPU/GPU ratio nextime
Generaly HPC script performs faster if you have fast Intel 4 core with HT enabled and 10th Gen. series nVidia HW.
If you have latest multi core CPU and Nvidia GTX 10th or 20th series you can benefit from MPC scripts. Speedup another 50%.
For ATI/AMD users use _CPU_conversion.cmd driven by CPU only.

Quality
No drop. Its the same.
If conversion fails on some files you will be noticed and you should check them for bad data.
If this will happen, make conversion for those files only again or download them again.
Overcloked CPU are not recommended, can cause errors, crashes.

Installation
Put all cmd, bat, dll and exe files to folder with textures (JPG)

Requirements
Windows Vista or later operating system for executables
DirectX9 or newer installed
CUDA driver installed for HPC script (comes with nvidia display driver package)
more than 8 JPEG files for HPC scheduler
more than 16 JPEG files for MPC scheduler

Usage
Run CMD file of your choice according to your hardware vendor. Do not run node or cuda files alone. Follow on screen messages
_CPU_Conversion is for CPU only conversion, recommended for ATI/AMD users
_HPC_CUDA is for nvidia owners, speed up 50%, 4 multicore CPU needed.
_MPC_CUDA is for nvidia owners, speed up 85% to _CPU_Conversion, 8 multicore CPU needed.
_UltraMPC_CUDA is extreme version, speed up 97%, 16+ multicore CPU needed. High end stable PC and HW monitoring software recommended.
Note to Ultra version. Watch your HW monitors, quit or stop conversion if temperatures goes off the limits!
Enter the percentage for GPU from your desired ratio in HPC/MPC scripts (not the same for each script)
Converts all JPG files in the directory to DDS (DXT1) texture format used in orthophoto sceneries
Prompt for deleting unecessary files
Error reporting with log file missing.inf
Logging into timer textfile for further analysis
Run executables in the command prompt for other options and usage (not usable for Frokboy2s packages)

Tested on
DX11
Windows 7 64-bit, Windows 10 Pro 64-bit
Intel CPUs i3, CoreDuo, 2x Xeon E5 2643, 2x Xeon E5 2667 v2
Intel HD graphics, Nvidia GTX750Ti, Nvidia GTX1070Ti

source, executables and updates:
https://github.com/Microsoft/DirectXTex/releases
http://www.x-plane.org

gastonreif@gmail.com 2020
Version 2.5rc1
