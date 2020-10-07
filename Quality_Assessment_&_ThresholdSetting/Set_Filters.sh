#!/bin/bash
#SBATCH -p serial
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --time=23:55:00
#SBATCH --mem=118G
#SBATCH -o Filter.%J.out
#SBATCH -e Filter.%J.err

module load gencore
module load gencore_variant_detection


VCF_IN=/scratch/da2451/Xenopus/Boissinotlab/gvcf/xenopus_genotype.vcf.gz
VCF_OUT=/scratch/da2451/Xenopus/Boissinotlab/gvcf/xenopus_genotype_filtered.vcf.gz


# set filters:

MAF=
MISS=
QUAL=30
MIN_DEPTH=2
MAX_DEPTH=10

# move to the vcf directory

cd gvcf

# perform the filtering with vcftools

vcftools --gzvcf $VCF_IN \
--remove-indels --maf $MAF --max-missing $MISS --minQ $QUAL \
--min-meanDP $MIN_DEPTH --max-meanDP $MAX_DEPTH \
--minDP $MIN_DEPTH --maxDP $MAX_DEPTH --recode --stdout | gzip -c > \
$VCF_OUT

cat out.log
bcftools view -H xenopus_genotype_filtered.vcf.gz | wc -l








