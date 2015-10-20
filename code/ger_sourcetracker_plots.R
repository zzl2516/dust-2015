## Summarize Gerlinger SourceTracker results
## Roxana Hickey <roxana.hickey@gmail.com
## 2015-10-20

# setwd('~/Documents/gerlinger/')
library(ggplot2)
library(reshape)
library(RColorBrewer)

## input sourcetracker results (R data)
load('results/sourcetracker_out/L5_family/results.RData')
res.fam <- results

load('results/sourcetracker_out/L6_genus/results.RData')
res.gen <- results

load('results/sourcetracker_out/L6_genus_noindoor/results.RData')
res.gen.noind <- results

rm(results)

## input sourcetracker output map files
map.fam <- read.table('results/sourcetracker_out/L5_family/map.txt',
                      header = T, sep = '\t', row.names = 1, comment.char = '')

map.gen <- read.table('results/sourcetracker_out/L6_genus/map.txt',
                      header = T, sep = '\t', row.names = 1, comment.char = '')

map.gen.noind <- read.table('results/sourcetracker_out/L6_genus_noindoor/map.txt',
                            header = T, sep = '\t', row.names = 1, comment.char = '')

## exclude samples with fewer than 1000 reads (the rarefied sampling level)
## oneuL3031: 4.0
## oneuLP1: 18.0
## oneuLFT6: 21.0
## oneuLP2: 23.0
## oneuLC1: 396.0

sample.ignore <- c('oneuL3031', 'oneuLP1', 'oneuLFT6', 'oneuLP2', 'oneuLC1')
sample.all <- rownames(map.fam)[grep('oneuL', rownames(map.fam))]
sample.pick <- sample.all[!(sample.all %in% sample.ignore)]

## reduce maps to source/sink proportions
prop.pick <- c('Env', 'Proportion_Human.Feces', 'Proportion_Human.Mouth', 'Proportion_Human.Skin', 
               'Proportion_Human.Urine', 'Proportion_Human.Vagina', 'Proportion_Indoor.Air',
               'Proportion_Outdoor.Air', 'Proportion_Soil', 'Proportion_Unknown')

prop.pick.noind <- c('Env', 'Proportion_Human.Feces', 'Proportion_Human.Mouth', 'Proportion_Human.Skin', 
                     'Proportion_Human.Urine', 'Proportion_Human.Vagina', 'Proportion_Outdoor.Air',
                     'Proportion_Soil', 'Proportion_Unknown')

prop.fam <- map.fam[sample.pick, prop.pick]
prop.fam$SampleID <- rownames(prop.fam)

prop.gen <- map.gen[sample.pick, prop.pick]
prop.gen$SampleID <- rownames(prop.gen)

prop.gen.noind <- map.gen.noind[sample.pick, prop.pick.noind]
prop.gen.noind$SampleID <- rownames(prop.gen.noind)

## make barplots
lg.prop.fam <- melt(prop.fam, id.vars = c('SampleID', 'Env'))
gg.prop.fam <- ggplot(lg.prop.fam, aes(x = SampleID, y = value, fill = variable))
gg.prop.fam + geom_bar(stat = 'identity') +
  scale_fill_manual(values = c(brewer.pal(9, 'YlOrRd')[c(8,7,5,3,1)], 
                               brewer.pal(11, 'Spectral')[c(11,10,9)], 
                               'grey90'),
                    labels = c('Human Feces', 'Human Mouth', 'Human Skin',
                               'Human Urine', 'Human Vagina', 'Indoor Air',
                               'Outdoor Air', 'Soil', 'Unknown'),
                    name = 'Putative Source') +
  coord_flip() +
  theme_bw()
ggsave('figures/ger_sourcetracker_family.png', width = 8, height = 10)


##
lg.prop.gen <- melt(prop.gen, id.vars = c('SampleID', 'Env'))
gg.prop.gen <- ggplot(lg.prop.gen, aes(x = SampleID, y = value, fill = variable))
gg.prop.gen + geom_bar(stat = 'identity') +
  scale_fill_manual(values = c(brewer.pal(9, 'YlOrRd')[c(8,7,5,3,1)], 
                               brewer.pal(11, 'Spectral')[c(11,10,9)], 
                               'grey90'),
                    labels = c('Human Feces', 'Human Mouth', 'Human Skin',
                               'Human Urine', 'Human Vagina', 'Indoor Air',
                               'Outdoor Air', 'Soil', 'Unknown'),
                    name = 'Putative Source') +
  coord_flip() +
  theme_bw()
ggsave('figures/ger_sourcetracker_genus.png', width = 8, height = 10)

##
lg.prop.gen.noind <- melt(prop.gen.noind, id.vars = c('SampleID', 'Env'))
gg.prop.gen.noind <- ggplot(lg.prop.gen.noind, aes(x = SampleID, y = value, fill = variable))
gg.prop.gen.noind + geom_bar(stat = 'identity') +
  scale_fill_manual(values = c(brewer.pal(9, 'YlOrRd')[c(8,7,5,3,1)], 
                               brewer.pal(11, 'Spectral')[c(10,9)], 
                               'grey90'),
                    labels = c('Human Feces', 'Human Mouth', 'Human Skin',
                               'Human Urine', 'Human Vagina', 'Outdoor Air',
                               'Soil', 'Unknown'),
                    name = 'Putative Source') +
  coord_flip() +
  theme_bw()
ggsave('figures/ger_sourcetracker_genus_noindoor.png', width = 8, height = 10)