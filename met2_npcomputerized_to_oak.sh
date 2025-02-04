#!/bin/bash
#daelsaid 02/03 - script will copy over the data from np computerized behav data that was transferred from the NP computer used during the assessment. subjects may or may not have immaging data, but subjects will  be reorganized and copied to rawdata/scsnl


usage() {
    echo "Usage: met2_npcomputerized_to_oak <subject_visit_session_behavioral> <subject_visit_session_behavioral>"
    echo
    echo "Options:"
    echo "  -h, --help    Display this help message and exit, this is not needed if you dont want to see this message"
    echo "Usage: met2_npcomputerized_to_oak -h <subject_visit_session_behavioral>"
    echo
    echo "Arguments:"
    echo "  subject_visit_session_behavioral    (name of subject folder- in the format PID_visit_session e.g., 9541_1_1_behavioral 15163_1_1_behavioral)"
    echo
    echo "Description:"
    echo "  This function processes neuropsychological computerized assessment data for specified"
    echo "  subject visit sessions. It organizes the data into the appropriate directories and"
    echo "  renames files by adding a prefix based on the subject's PID, visit, and session."
    echo
}




function met2_npcomputerized_to_oak() {
    rawdir='/oak/stanford/groups/menon/rawdata/scsnl'
    # rawdir='/scratch/users/daelsaid/test_met2'
    temp_behav_dir_path=/oak/stanford/groups/menon/rawdata/.np_behavioural_assessments

    # subj=9541_1_1_behavioral
    # for subj_visit_sess in "$subj"; do

    for arg in "$@"; do
        if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
            usage
            return 0
        fi
    done

    if [ "$#" -eq 0 ]; then
        echo "Error: No arguments provided."
        usage
        return 1

    fi

    for subj_visit_sess in "$@"; do
        echo "Processing: $subj_visit_sess";
        pid=`echo $subj_visit_sess | cut -d'_' -f1`
        visit=`echo $subj_visit_sess | cut -d'_' -f2`
        session=`echo $subj_visit_sess | cut -d'_' -f3`

        echo ${pid}, visit ${visit}, session ${session}
        prefix="${pid}_${visit}_${session}_"
        

        #temp dir paths
        comp_tasks=`find ${temp_behav_dir_path}/${subj_visit_sess} -name '*comp*run*.csv' -type f`
        ord_tasks=`find ${temp_behav_dir_path}/${subj_visit_sess} -name '*ord*run*.csv' -type f`
        arithmetic_tasks=`find ${temp_behav_dir_path}/${subj_visit_sess} -name '*arithmetic*run*.csv' -type f`
        numberline_tasks=`find ${temp_behav_dir_path}/${subj_visit_sess} -name '*NumberLine*.csv' -type f`
        ordimage_dir=${temp_behav_dir_path}/${subj_visit_sess}/Results/OrdImages
        compimage_dir=${temp_behav_dir_path}/${subj_visit_sess}/Results/CompImages

        # raw data dir
        behav_oak_dir=${rawdir}/${pid}/visit${visit}/session${session}/behavioral
        numberskills_battery_dir=${behav_oak_dir}/number_skills_battery

        compdir=${numberskills_battery_dir}/comparison
        orddir=${numberskills_battery_dir}/ordering
        arithmeticdir=${numberskills_battery_dir}/arithmetic
        numberlinedir=${numberskills_battery_dir}/numberline

        echo 
        if [ ! -d "$numberskills_battery_dir" ]; then
            echo "Behavioral directory does not exist, creating $numberskills_battery_dir"
            mkdir -p "${behav_oak_dir}"
            echo "copying template folder to subject's behav folder on oak"
            rsync -azvp ${temp_behav_dir_path}/number_skills_battery_template/ ${behav_oak_dir}/number_skills_battery
            rsync -avp ${comp_tasks} ${compdir}; rsync -avp ${ord_tasks} ${orddir}; rsync -avp ${arithmetic_tasks} ${arithmeticdir}; rsync -avp ${numberline_tasks} ${numberlinedir};
            echo "zipping OrdImages and CompImages" 
            zip -r "${orddir}/OrdImages.zip" "${ordimage_dir}"
            zip -r "${compdir}/CompImages.zip" "${compimage_dir}"
        else
            echo "Number skills battery directory exists: $numberskills_battery_dir"
            continue
        fi

        for file in `find ${numberskills_battery_dir}/*/*.csv`; do
            fname=`echo $(basename $file)`
            # filewpath=`realpath ${file}`;
            fpath=`echo $(dirname $file)`

            if [ -f "$file" ]; then
                if [[ "$file" != "${fpath}/${prefix}*" ]]; then
                    mv "$file" "${fpath}/${prefix}${fname}"
                    echo "Renamed $file to ${prefix}${fname}"
                else
                    echo "File $file already has the prefix, skipping."
                fi
            fi
        done
    done
}
