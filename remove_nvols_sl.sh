#!/bin/bash

function remove_nvols_sl () {
    load_preproc_modules;
    rawdir='/oak/stanford/groups/menon/projects/daelsaid/2022_speaker_listener/data/imaging/participants'
    
    for subj_visit_sess in "$@"; do
        echo $subj_visit_sess;
        nii_orig=`ls -d ${rawdir}/${subj_visit_sess}/fmri/*/un*/I.nii.gz | grep -v rest | grep -v failed | grep -v pepolar | grep -v calib`;
        for nii in ${nii_orig}; do
            taskname=`echo $nii | cut -d/ -f16`;
            # echo `echo $nii | cut -d/ -f1,5` `mri_info $nii | grep nframes`;
            nframes=`mri_info $nii | grep nframes | cut -d':' -f2 | sed 's/^ //'`;
            orig_file=$(dirname ${nii})/I_orig.nii.gz;
            if [ -f "$orig_file" ]; then
                orig_nframes=$(mri_info "$orig_file" | grep nframes | cut -d':' -f2)
                final_vols=$((orig_nframes - 15))
                if [ "$nframes" -eq "$final_vols" ] && [ "$orig_nframes" -eq "$((final_vols + 15))" ]; then
                    echo "Skipping: $nii (Already processed)"
                    continue
                fi
            fi
        if [ ! -f "$orig_file" ]; then
            echo "Processing:`echo $nii | cut -d/ -f12-` (nframes: $nframes)";                 
            new=`echo $(dirname $nii)/I_orig.nii.gz`;                 
            cp ${nii} ${new};
            orig_nframes=$(mri_info "$new" | grep nframes | cut -d':' -f2)
            final_vols=$((orig_nframes - 15))

            if [ "$nframes" -gt "$final_vols" ]; then
                echo "Removing first 15 volumes from ${taskname}..."
                fslroi ${nii} ${nii} 15 ${nframes}
                nframes=`mri_info $nii | grep nframes | cut -d':' -f2`;
                echo "new vols for $taskname $nframes"
            else
                echo "Skipping: $nii (nframes: $nframes)";
            fi
        fi
        done
    done
}