#!/bin/bash
#SBATCH -p serial
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --time=23:55:00
#SBATCH --mem=118G
#SBATCH -o Genotype_stat.%J.out
#SBATCH -e Genotype_stat.%J.err

module load gencore
module load gencore_variant_detection

# Checking number of variants:

bcftools view -H xenopus_genotype.vcf.gz | wc -l

# Randomly subsampling a VCF:

bcftools view xenopus_genotype.vcf.gz | vcfrandomsample -r 0.012 > xenopus_genotype_subset2.vcf

# compress vcf

bcftools view xenopus_genotype_subset2.vcf -Oz -o xenopus_genotype_subset2.vcf.gz

# index vcf

bcftools index xenopus_genotype_subset2.vcf.gz

# Generating statistics from a VCF to set filtering threshold:

SET_VCF=/scratch/da2451/Xenopus/Boissinotlab/gvcf/xenopus_genotype_subset2.vcf.gz
OUT=/scratch/da2451/Xenopus/Boissinotlab/gvcf/Stat_vcf_genotype/xenopus_genotype_subset2

# Calculate allele frequency:

vcftools --gzvcf $SET_VCF --freq2 --out $OUT --max-alleles 2

vcftools --gzvcf $SET_VCF --freq --out $OUT --max-alleles 2

# Calculate mean depth per individual:

vcftools --gzvcf $SET_VCF --depth --out $OUT

# Calculate mean depth per variant:

vcftools --gzvcf $SET_VCF --site-mean-depth --out $OUT

# Calculate site quality:

vcftools --gzvcf $SET_VCF --site-quality --out $OUT

# Calculate proportion of missing data per individual:

vcftools --gzvcf $SET_VCF --missing-indv --out $OUT

# Calculate proportion of missing data per site:

vcftools --gzvcf $SET_VCF --missing-site --out $OUT

# Calculate heterozygosity:

vcftools --gzvcf $SET_VCF --het --out $OUT


