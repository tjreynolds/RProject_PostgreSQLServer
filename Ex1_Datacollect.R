drv <- dbDriver("PostgreSQL")
host <- '127.0.0.1'
port <- '5432'
username <- 'vagrant'
password <- 'vagrant'

conn <- dbConnect(drv, dbname = 'hg19db', username, password, host, port)

bdp  <- dbGetQuery(conn, "SELECT pos.chrom as chrom, pos.txStart as pos_tss, neg.txEnd as neg_tss, pos.name2 as pos_gene, neg.name2 as neg_gene, (pos.txStart - neg.txEnd) as spacing FROM  (SELECT * from hg19_refgene WHERE strand = '+') AS pos, (SELECT * from hg19_refgene WHERE strand = '-') AS neg WHERE pos.chrom = neg.chrom AND abs(neg.txEnd - pos.txStart) < 1000")
