version 1.0

workflow clipseq {
	input{
		File samplesheet
		String outdir = "./results"
		String? email
		String? genome
		String? smrna_org
		String? smrna_fasta
		File? fasta
		String? fai
		String? gtf
		String? star_index
		Boolean? save_index
		String igenomes_base = "s3://ngi-igenomes/igenomes/"
		Boolean? igenomes_ignore
		String adapter = "AGATCGGAAGAGC"
		String move_umi = "false"
		Boolean deduplicate = true
		String umi_separator = ":"
		String? peakcaller
		String? segment
		Int half_window = 3
		Int merge_window = 3
		Int min_value = 10
		Int min_density_increase = 2
		Int max_cluster_length = 200
		Int? pureclip_bc
		Int pureclip_dm = 8
		String pureclip_iv = "all"
		Int bin_size_both = 3
		Int cluster_dist = 3
		Boolean? motif
		Int motif_sample = 1000
		Boolean? help
		String publish_dir_mode = "copy"
		Boolean validate_params = true
		String? email_on_fail
		Boolean? plaintext_email
		String max_multiqc_email_size = "25.MB"
		Boolean? monochrome_logs
		String? multiqc_config
		String tracedir = "./results/pipeline_info"
		Boolean? show_hidden_params
		Int max_cpus = 16
		String max_memory = "128.GB"
		String max_time = "240.h"
		String custom_config_version = "master"
		String custom_config_base = "https://raw.githubusercontent.com/nf-core/configs/master"
		String? hostnames
		String? config_profile_name
		String? config_profile_description
		String? config_profile_contact
		String? config_profile_url

	}

	call make_uuid as mkuuid {}
	call touch_uuid as thuuid {
		input:
			outputbucket = mkuuid.uuid
	}
	call run_nfcoretask as nfcoretask {
		input:
			samplesheet = samplesheet,
			outdir = outdir,
			email = email,
			genome = genome,
			smrna_org = smrna_org,
			smrna_fasta = smrna_fasta,
			fasta = fasta,
			fai = fai,
			gtf = gtf,
			star_index = star_index,
			save_index = save_index,
			igenomes_base = igenomes_base,
			igenomes_ignore = igenomes_ignore,
			adapter = adapter,
			move_umi = move_umi,
			deduplicate = deduplicate,
			umi_separator = umi_separator,
			peakcaller = peakcaller,
			segment = segment,
			half_window = half_window,
			merge_window = merge_window,
			min_value = min_value,
			min_density_increase = min_density_increase,
			max_cluster_length = max_cluster_length,
			pureclip_bc = pureclip_bc,
			pureclip_dm = pureclip_dm,
			pureclip_iv = pureclip_iv,
			bin_size_both = bin_size_both,
			cluster_dist = cluster_dist,
			motif = motif,
			motif_sample = motif_sample,
			help = help,
			publish_dir_mode = publish_dir_mode,
			validate_params = validate_params,
			email_on_fail = email_on_fail,
			plaintext_email = plaintext_email,
			max_multiqc_email_size = max_multiqc_email_size,
			monochrome_logs = monochrome_logs,
			multiqc_config = multiqc_config,
			tracedir = tracedir,
			show_hidden_params = show_hidden_params,
			max_cpus = max_cpus,
			max_memory = max_memory,
			max_time = max_time,
			custom_config_version = custom_config_version,
			custom_config_base = custom_config_base,
			hostnames = hostnames,
			config_profile_name = config_profile_name,
			config_profile_description = config_profile_description,
			config_profile_contact = config_profile_contact,
			config_profile_url = config_profile_url,
			outputbucket = thuuid.touchedbucket
            }
		output {
			Array[File] results = nfcoretask.results
		}
	}
task make_uuid {
	meta {
		volatile: true
}

command <<<
        python <<CODE
        import uuid
        print("gs://truwl-internal-inputs/nf-clipseq/{}".format(str(uuid.uuid4())))
        CODE
>>>

  output {
    String uuid = read_string(stdout())
  }
  
  runtime {
    docker: "python:3.8.12-buster"
  }
}

task touch_uuid {
    input {
        String outputbucket
    }

    command <<<
        echo "sentinel" > sentinelfile
        gsutil cp sentinelfile ~{outputbucket}/sentinelfile
    >>>

    output {
        String touchedbucket = outputbucket
    }

    runtime {
        docker: "google/cloud-sdk:latest"
    }
}

task fetch_results {
    input {
        String outputbucket
        File execution_trace
    }
    command <<<
        cat ~{execution_trace}
        echo ~{outputbucket}
        mkdir -p ./resultsdir
        gsutil cp -R ~{outputbucket} ./resultsdir
    >>>
    output {
        Array[File] results = glob("resultsdir/*")
    }
    runtime {
        docker: "google/cloud-sdk:latest"
    }
}

task run_nfcoretask {
    input {
        String outputbucket
		File samplesheet
		String outdir = "./results"
		String? email
		String? genome
		String? smrna_org
		String? smrna_fasta
		File? fasta
		String? fai
		String? gtf
		String? star_index
		Boolean? save_index
		String igenomes_base = "s3://ngi-igenomes/igenomes/"
		Boolean? igenomes_ignore
		String adapter = "AGATCGGAAGAGC"
		String move_umi = "false"
		Boolean deduplicate = true
		String umi_separator = ":"
		String? peakcaller
		String? segment
		Int half_window = 3
		Int merge_window = 3
		Int min_value = 10
		Int min_density_increase = 2
		Int max_cluster_length = 200
		Int? pureclip_bc
		Int pureclip_dm = 8
		String pureclip_iv = "all"
		Int bin_size_both = 3
		Int cluster_dist = 3
		Boolean? motif
		Int motif_sample = 1000
		Boolean? help
		String publish_dir_mode = "copy"
		Boolean validate_params = true
		String? email_on_fail
		Boolean? plaintext_email
		String max_multiqc_email_size = "25.MB"
		Boolean? monochrome_logs
		String? multiqc_config
		String tracedir = "./results/pipeline_info"
		Boolean? show_hidden_params
		Int max_cpus = 16
		String max_memory = "128.GB"
		String max_time = "240.h"
		String custom_config_version = "master"
		String custom_config_base = "https://raw.githubusercontent.com/nf-core/configs/master"
		String? hostnames
		String? config_profile_name
		String? config_profile_description
		String? config_profile_contact
		String? config_profile_url

	}
	command <<<
		export NXF_VER=21.10.5
		export NXF_MODE=google
		echo ~{outputbucket}
		/nextflow -c /truwl.nf.config run /clipseq-1.0.0  -profile truwl,nfcore-clipseq  --input ~{samplesheet} 	~{"--samplesheet '" + samplesheet + "'"}	~{"--outdir '" + outdir + "'"}	~{"--email '" + email + "'"}	~{"--genome '" + genome + "'"}	~{"--smrna_org '" + smrna_org + "'"}	~{"--smrna_fasta '" + smrna_fasta + "'"}	~{"--fasta '" + fasta + "'"}	~{"--fai '" + fai + "'"}	~{"--gtf '" + gtf + "'"}	~{"--star_index '" + star_index + "'"}	~{true="--save_index  " false="" save_index}	~{"--igenomes_base '" + igenomes_base + "'"}	~{true="--igenomes_ignore  " false="" igenomes_ignore}	~{"--adapter '" + adapter + "'"}	~{"--move_umi '" + move_umi + "'"}	~{true="--deduplicate  " false="" deduplicate}	~{"--umi_separator '" + umi_separator + "'"}	~{"--peakcaller '" + peakcaller + "'"}	~{"--segment '" + segment + "'"}	~{"--half_window " + half_window}	~{"--merge_window " + merge_window}	~{"--min_value " + min_value}	~{"--min_density_increase " + min_density_increase}	~{"--max_cluster_length " + max_cluster_length}	~{"--pureclip_bc " + pureclip_bc}	~{"--pureclip_dm " + pureclip_dm}	~{"--pureclip_iv '" + pureclip_iv + "'"}	~{"--bin_size_both " + bin_size_both}	~{"--cluster_dist " + cluster_dist}	~{true="--motif  " false="" motif}	~{"--motif_sample " + motif_sample}	~{true="--help  " false="" help}	~{"--publish_dir_mode '" + publish_dir_mode + "'"}	~{true="--validate_params  " false="" validate_params}	~{"--email_on_fail '" + email_on_fail + "'"}	~{true="--plaintext_email  " false="" plaintext_email}	~{"--max_multiqc_email_size '" + max_multiqc_email_size + "'"}	~{true="--monochrome_logs  " false="" monochrome_logs}	~{"--multiqc_config '" + multiqc_config + "'"}	~{"--tracedir '" + tracedir + "'"}	~{true="--show_hidden_params  " false="" show_hidden_params}	~{"--max_cpus " + max_cpus}	~{"--max_memory '" + max_memory + "'"}	~{"--max_time '" + max_time + "'"}	~{"--custom_config_version '" + custom_config_version + "'"}	~{"--custom_config_base '" + custom_config_base + "'"}	~{"--hostnames '" + hostnames + "'"}	~{"--config_profile_name '" + config_profile_name + "'"}	~{"--config_profile_description '" + config_profile_description + "'"}	~{"--config_profile_contact '" + config_profile_contact + "'"}	~{"--config_profile_url '" + config_profile_url + "'"}	-w ~{outputbucket}
	>>>
        
    output {
        File execution_trace = "pipeline_execution_trace.txt"
        Array[File] results = glob("results/*/*html")
    }
    runtime {
        docker: "truwl/nfcore-clipseq:1.0.0_0.1.0"
        memory: "2 GB"
        cpu: 1
    }
}
    