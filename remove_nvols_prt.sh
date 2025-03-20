#!/bin/bash

function remove_nvols_prt () {     
    load_preproc_modules;    
    rawdir='/oak/stanford/groups/menon/projects/daelsaid/2023_prt_hfa/data/imaging/participants';      
    
    for subj_visit_sess in "$@"; do         
        echo $subj_visit_sess;        
        #echo $(ls -d ${subj_visit_sess}/fmri/*PRT*/un*/I.nii.gz | grep -v rest | grep -v pepolar | grep -v calibration);         
        nii_orig=$(ls -d ${rawdir}/${subj_visit_sess}/fmri/*PRT*/un*/I.nii.gz | grep -v rest | grep -v PRT_10_tp | grep -v PRT_09_dm | grep -v pepolar | grep -v calibration);         
        # echo $nii_orig;         
        for nii in ${nii_orig}; do             
            taskname=`echo $nii | cut -d/ -f16`;             
            # echo `echo $nii | cut -d/ -f1,5` `mri_info $nii | grep nframes`;             
            nframes=`mri_info $nii | grep nframes | cut -d':' -f2 | sed 's/^ //'`;             
            orig_file=$(dirname ${nii})/I_orig.nii.gz;             
            if [ -f "$orig_file" ]; then                 
                orig_nframes=$(mri_info "$orig_file" | grep nframes | cut -d':' -f2);                 
                final_vols=$((orig_nframes - 2));                 
                if [ "$nframes" -eq "$final_vols" ] && [ "$orig_nframes" -eq "$((final_vols + 2))" ]; then                     
                    echo "Skipping: $nii (Already processed)";                     
                    continue;                 
                fi;             
            fi;
            if [ ! -f "$orig_file" ]; then
                echo "Processing:`echo $nii | cut -d/ -f12-` (nframes: $nframes)";                 
                new=`echo $(dirname $nii)/I_orig.nii.gz`;                 
                cp ${nii} ${new};
                orig_nframes=$(mri_info "$new" | grep nframes | cut -d':' -f2)
                final_vols=$((orig_nframes - 2));                 
                if [ "$nframes" -gt "$final_vols" ]; then                 
                    echo "Removing first 2 volumes from ${taskname}...";                 
                    fslroi ${nii} ${nii} 2 ${nframes};                 
                    nframes=`mri_info $nii | grep nframes | cut -d':' -f2`;                 
                    echo "new vols for $taskname $nframes";\
                else
                    echo "Skipping: $nii (nframes: $nframes)";
                fi             
            fi;
        nii_tp=$(ls -d ${rawdir}/${subj_visit_sess}/fmri/*PRT_10_tp_mv2_func*/un*/I.nii.gz | grep -v rest | grep -v PRT_09_dm | grep -v pepolar | grep -v calibration);         #13 270 
        if [ -n "$nii_tp" ]; then  # Ensure the file exists
            taskname=`echo $nii_tp | cut -d/ -f16`;             
            nframes=`mri_info $nii_tp | grep nframes | cut -d':' -f2 | sed 's/^ //'`;             
            orig_file=$(dirname ${nii_tp})/I_orig.nii.gz;             
            if [ -f "$orig_file" ]; then                 
                orig_nframes=$(mri_info "$orig_file" | grep nframes | cut -d':' -f2);                 
                final_vols=$((orig_nframes - 13));                 
                if [ "$nframes" -eq "$final_vols" ] && [ "$orig_nframes" -eq "$((final_vols + 13))" ]; then                     
                    echo "Skipping: $nii_tp (Already processed)";                     
                    continue;                 
                fi;             
            fi;
            if [ ! -f "$orig_file" ]; then
                echo "Processing: $(echo $nii_tp | cut -d/ -f12-) (nframes: $nframes)";                 
                new=`echo $(dirname $nii_tp)/I_orig.nii.gz`;                 
                cp ${nii_tp} ${new};
                orig_nframes=$(mri_info "$new" | grep nframes | cut -d':' -f2)
                final_vols=$((orig_nframes - 13));                 
                if [ "$nframes" -gt "$final_vols" ]; then                 
                    echo "Removing first 2 volumes from ${taskname}...";                 
                    fslroi ${nii_tp} ${nii_tp} 13 ${nframes};      #13 270            
                    nframes=`mri_info $nii_tp | grep nframes | cut -d':' -f2`;                 
                    echo "new vols for $taskname $nframes";
                else
                    echo "Skipping: $nii_tp (nframes: $nframes)";
                fi             
            fi;
        else
            echo "No PRT_10_tp_mv2_func file found for $subj_visit_sess, skipping the present processing."
        fi
        nii_dm=$(ls -d ${rawdir}/${subj_visit_sess}/fmri/PRT_09_dm_mv1_func/un*/I.nii.gz | grep -v rest | grep -v PRT_10_dm | grep -v pepolar | grep -v calibration);         #13 775
        if [ -n "$nii_dm" ]; then  # Ensure the file exists
            taskname=`echo $nii_dm | cut -d/ -f16`;             
            nframes=`mri_info $nii_dm | grep nframes | cut -d':' -f2 | sed 's/^ //'`;             
            orig_file=$(dirname ${nii_dm})/I_orig.nii.gz;             
            if [ -f "$orig_file" ]; then                 
                orig_nframes=$(mri_info "$orig_file" | grep nframes | cut -d':' -f2);                 
                final_vols=$((orig_nframes - 13));                 
                if [ "$nframes" -eq "$final_vols" ] && [ "$orig_nframes" -eq "$((final_vols + 13))" ]; then                     
                    echo "Skipping: $nii_dm (Already processed)";                     
                    continue;                 
                fi;             
            fi;
            if [ ! -f "$orig_file" ]; then
                echo "Processing: $(echo $nii_tp | cut -d/ -f12-) (nframes: $nframes)";                 
                new=`echo $(dirname $nii_dm)/I_orig.nii.gz`;                 
                cp ${$nii_dm} ${new};
                orig_nframes=$(mri_info "$new" | grep nframes | cut -d':' -f2)
                final_vols=$((orig_nframes - 13));                 
                if [ "$nframes" -gt "$final_vols" ]; then                 
                    echo "Removing first 2 volumes from ${taskname}...";                 
                    fslroi ${nii_dm} ${nii_dm} 13 ${nframes};      #13 775            
                    nframes=`mri_info $nii_dm | grep nframes | cut -d':' -f2`;                 
                    echo "new vols for $taskname $nframes";\
                else
                    echo "Skipping: $nii_dm (nframes: $nframes)";
                fi             
            fi;
        else
            echo "No PRT_09_dm_mv1_func file found for $subj_visit_sess, skipping despicable me processing."
        fi
        done;
    done;
}
