#!/bin/bash

#dawlat el-said 01/27/2025


# 15163/visit1/session1/fmri/order_num_run1 nframes: 530
# comp dot/num/mixed runs are all 434 volumes
# 15163/visit1/session1/fmri/comp_dot_run2 nframes: 434
# 15163/visit1/session1/fmri/resting nframes: 392
# 15163/visit1/session1/fmri/vswm_run1 nframes: 348
# 15163/visit1/session1/fmri/vswm_run2 nframes: 348




function rnvols() {
    rawdir='/oak/stanford/groups/menon/rawdata/scsnl'
    # rawdir='/scratch/users/daelsaid/test_met2'
    load_preproc_modules;
    d=$(date +%m_%d_%Y_%T | tr ':' '_' | cut -d_ -f1-5);

    for subj_visit_sess in "$@"; do
        echo "Processing: $subj_visit_sess";

        # Process order_*_run? scans
        nii_order=`ls -d ${rawdir}/${subj_visit_sess}/fmri/order_*/un*/I.nii.gz | grep -v 'pepolar'`;
        for nii in ${nii_order}; do
            taskname=`echo $nii | cut -d/ -f12`;
            nframes=`mri_info $nii | grep nframes | cut -d':' -f2 | sed 's/^ //'`
            orig_file=$(dirname ${nii})/I_orig.nii.gz
            if [ -f "$orig_file" ]; then
                orig_nframes=`mri_info $orig_file | grep nframes | cut -d':' -f2 | sed 's/^ //'`
                if [ "$nframes" -eq 514 ] && [ "$orig_nframes" -eq 530 ]; then
                    echo "Skipping: $nii (Already processed)"
                    continue
                fi
            fi
            if [ "$nframes" -gt 514 ]; then
                echo "Processing: $nii (nframes: $nframes)"
                new=`echo $(dirname ${nii})/I_orig.nii.gz`;
                cp ${nii} ${new}
                echo "Removing first 16 volumes from ${taskname}..."
                fslroi ${nii} ${nii} 16 ${nframes}
            else
                echo "Skipping: $nii (nframes: $nframes)"
            fi
        done

        # comp task sare all 434 volumes
        nii_comp=`ls -d ${rawdir}/${subj_visit_sess}/fmri/comp_*_run*/un*/I.nii.gz | grep -v 'pepolar'`;
        for nii in ${nii_comp}; do
            taskname=`echo $nii | cut -d/ -f12`;
            nframes=`mri_info $nii | grep nframes | cut -d':' -f2 | sed 's/^ //' `
            orig_file=$(dirname ${nii})/I_orig.nii.gz
            # orig_nframes=`mri_info $orig_file | grep nframes | cut -d':' -f2`
            if [ -f "$orig_file" ]; then
                orig_nframes=`mri_info $orig_file | grep nframes | cut -d':' -f2 | sed 's/^ //'`
                if [ "$nframes" -eq 418 ] && [ "$orig_nframes" -eq 434 ]; then
                    echo "Skipping: $nii (Already processed)"
                    continue
                fi
            fi
            if [ "$nframes" -gt 418 ]; then
                echo "Processing: $nii (nframes: $nframes)"
                new=`echo $(dirname ${nii})/I_orig.nii.gz`;
                cp ${nii} ${new}
                echo "Removing first 16 volumes from ${taskname}..."
                fslroi ${nii} ${nii} 16 ${nframes}
            else
                echo "Skipping: $nii (nframes: $nframes)"
            fi
        done

        # vswm task sare all 348 volumes
        nii_vswm=`ls -d ${rawdir}/${subj_visit_sess}/fmri/vswm_run*/un*/I.nii.gz | grep -v 'pepolar'`;
        for nii in ${nii_vswm}; do
            taskname=`echo $nii | cut -d/ -f12`;
            nframes=`mri_info $nii | grep nframes | cut -d':' -f2 | sed 's/^ //' `
            orig_file=$(dirname ${nii})/I_orig.nii.gz
            # orig_nframes=`mri_info $orig_file | grep nframes | cut -d':' -f2`

            if [ -f "$orig_file" ]; then
                orig_nframes=`mri_info $orig_file | grep nframes | cut -d':' -f2 | sed 's/^ //'`
                if [ "$nframes" -eq 332 ] && [ "$orig_nframes" -eq 348 ]; then
                    echo "Skipping: $nii (Already processed)"
                    continue
                fi
            fi
            if [ "$nframes" -gt 332 ]; then
                echo "Processing: $nii (nframes: $nframes)"
                new=`echo $(dirname ${nii})/I_orig.nii.gz`;
                cp ${nii} ${new}
                echo "Removing first 16 volumes from ${taskname}..."
                fslroi ${nii} ${nii} 16 ${nframes}
            else
                echo "Skipping: $nii (nframes: $nframes)"
            fi
        done

        # resting task sare all 392 volumes
        nii_rest=`ls -d ${rawdir}/${subj_visit_sess}/fmri/resting*/un*/I.nii.gz | grep -v 'pepolar'`;
        for nii in ${nii_rest}; do
            taskname=`echo $nii | cut -d/ -f12`;
            nframes=`mri_info $nii | grep nframes | cut -d':' -f2 | sed 's/^ //' `
            orig_file=$(dirname ${nii})/I_orig.nii.gz
            # orig_nframes=`mri_info $orig_file | grep nframes | cut -d':' -f2`

            if [ -f "$orig_file" ]; then
                orig_nframes=`mri_info $orig_file | grep nframes | cut -d':' -f2 | sed 's/^ //'`
                if [ "$nframes" -eq 376 ] && [ "$orig_nframes" -eq 392 ]; then
                    echo "Skipping: $nii (Already processed)"
                    continue
                fi
            fi
            if [ "$nframes" -gt 376 ]; then
                echo "Processing: $nii (nframes: $nframes)"
                new=`echo $(dirname ${nii})/I_orig.nii.gz`;
                cp ${nii} ${new}
                echo "Removing first 16 volumes from ${taskname}..."
                fslroi ${nii} ${nii} 16 ${nframes}
            else
                echo "Skipping: $nii (nframes: $nframes)"
            fi
        done
    done
}

        
