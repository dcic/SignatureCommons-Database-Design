-- Create schemas

-- Create tables
CREATE TABLE IF NOT EXISTS signature
(
    signature_id INTEGER NOT NULL,
    assay_label TEXT,
    data_level INTEGER,
    dataset_id VARCHAR(80),
    PRIMARY KEY(signature_id)
);

CREATE TABLE IF NOT EXISTS signature_components
(
    signature_id INTEGER NOT NULL,
    component_key VARCHAR(80),
    component_value NUMERIC(14, 4),
    component_value_units VARCHAR(80),
    component_value_type VARCHAR(80)    
);

CREATE TABLE IF NOT EXISTS component_to_object
(
    component_key VARCHAR(80) NOT NULL,
    component_object_id INTEGER,
    PRIMARY KEY(component_key)
);

CREATE TABLE IF NOT EXISTS probe_p100
(
    component_object_id INTEGER NOT NULL,
    component_object_class VARCHAR(80),
		CHECK(component_object_class = 'probe_p100'),
    probe_id VARCHAR(80) NOT NULL UNIQUE,
    probe_name TEXT,
    PRIMARY KEY(probe_id),
	UNIQUE(component_object_id, component_object_class)
);

CREATE TABLE IF NOT EXISTS protein
(
    uniprot_accession VARCHAR(80) NOT NULL UNIQUE,
    component_object_id INTEGER NOT NULL,
    component_object_class VARCHAR(80),
		CHECK(component_object_class = 'protein'),
    uniprot_preferred_name TEXT,
    uniprot_preferred_gene_symbol VARCHAR(20),
    signature_object_id INTEGER,
    signature_object_class VARCHAR(80),
		CHECK(signature_object_class = 'protein'),
    PRIMARY KEY(uniprot_accession),
	UNIQUE(component_object_id, component_object_class),
	UNIQUE(signature_object_id, signature_object_class)
	
);

CREATE TABLE IF NOT EXISTS gene
(
    component_object_id INTEGER NOT NULL,
    component_object_class VARCHAR(80),
		CHECK(component_object_class = 'gene'),
    entrez_gene_id INTEGER NOT NULL,
    gene_organism TEXT,
    gene_symbol VARCHAR(80),
    gene_protein_uniprot_accession VARCHAR(80),
    signature_object_id INTEGER,
    signature_object_class VARCHAR(80),
		CHECK(signature_object_class = 'gene'),
    PRIMARY KEY(entrez_gene_id),
	UNIQUE(component_object_id, component_object_class),
	UNIQUE(signature_object_id, signature_object_class)
);

CREATE TABLE IF NOT EXISTS probe_p100_to_protein
(
    probe_id VARCHAR(80) NOT NULL,
    uniprot_accession VARCHAR(80)    
);

CREATE TABLE IF NOT EXISTS signature_to_object
(
    signature_id INTEGER NOT NULL,
    signature_object_id INTEGER    
);

CREATE TABLE IF NOT EXISTS cell_line
(
    signature_object_id INTEGER NOT NULL,
    signature_object_class VARCHAR(80),
		CHECK(signature_object_class = 'cell line'),
    cell_line_id VARCHAR(80) UNIQUE,
    cell_line_name TEXT,
    clo_id VARCHAR(80),
    cellosaurus_id VARCHAR(80),
	PRIMARY KEY(cell_line_id),
	UNIQUE(signature_object_id, signature_object_class)
);

CREATE TABLE IF NOT EXISTS disease
(
    doid VARCHAR(80) NOT NULL,
    disease_term TEXT,
    cell_line_id VARCHAR(80),
    PRIMARY KEY(doid)
);

CREATE TABLE IF NOT EXISTS signature_provenance
(
    signature_object_id INTEGER NOT NULL,
    signature_object_class VARCHAR(80),
		CHECK(signature_object_class = 'provenance'),
    resource_id INTEGER,
    activity_id INTEGER,
	resource_dataset_id TEXT,
    dataset_sample_id VARCHAR(80),
    UNIQUE(signature_object_id, signature_object_class)
);

CREATE TABLE IF NOT EXISTS generating_activity
(
    activity_id INTEGER NOT NULL,
    activity_name VARCHAR(80),
    activity_class VARCHAR(80),
    activity_description TEXT,
    activity_reference_url TEXT,
    PRIMARY KEY(activity_id)
);

CREATE TABLE IF NOT EXISTS resource
(
    resource_id INTEGER NOT NULL,
    resource_name TEXT,
    resource_type VARCHAR(80),
    resource_description TEXT,
    resource_url TEXT,
    PRIMARY KEY(resource_id)
);

CREATE TABLE IF NOT EXISTS perturbation
(
    signature_object_id INTEGER NOT NULL,
    signature_object_class VARCHAR(80),
		CHECK(signature_object_class = 'perturbation'),
    perturbagen_id VARCHAR(80),
    perturbagen_class VARCHAR(80),
    timepoint NUMERIC(5, 2),
    timepoint_units VARCHAR(20),
    concentration NUMERIC(6, 2),
    concentration_units VARCHAR(40),
	UNIQUE(signature_object_id, signature_object_class),
	UNIQUE(perturbagen_id, perturbagen_class)
);

CREATE TABLE IF NOT EXISTS cell_line_synonym
(
    cell_line_id VARCHAR(80) NOT NULL,
    synonym TEXT,
    synonym_type VARCHAR(80)    
);

CREATE TABLE IF NOT EXISTS small_molecule
(
    perturbagen_id VARCHAR(80) NOT NULL UNIQUE,
    perturbagen_class VARCHAR(80),
		CHECK(perturbagen_class = 'small molecule'),
    sm_name TEXT,
    pubchem_cid INTEGER,
    chembl_id INTEGER,
    max_fda_phase INTEGER,
    canonical_smiles TEXT,
    canonical_inchi TEXT,
    canonical_inchi_key TEXT,
	UNIQUE(perturbagen_id, perturbagen_class)
);

CREATE TABLE IF NOT EXISTS small_molecule_synonym
(
    perturbagen_id VARCHAR(80) NOT NULL,
    synonym TEXT,
    synonym_type VARCHAR(80)    
);

CREATE TABLE IF NOT EXISTS nucleic_acid_reagent
(
    perturbagen_id VARCHAR(80) NOT NULL,
    perturbagen_class VARCHAR(80),
		CHECK(perturbagen_class = 'nucleic acid reagent'),
    nar_type VARCHAR(40),
    entrez_gene_id INTEGER,
	UNIQUE(perturbagen_id, perturbagen_class)
);

CREATE TABLE IF NOT EXISTS signature_object_to_meta
(
    signature_object_id INTEGER NOT NULL UNIQUE,
    signature_object_class VARCHAR(80),
	UNIQUE(signature_object_id, signature_object_class)
);

CREATE TABLE IF NOT EXISTS component_object_to_meta
(
    component_object_id INTEGER NOT NULL UNIQUE,
    component_object_class VARCHAR(80),
	UNIQUE(component_object_id, component_object_class)
);

CREATE TABLE IF NOT EXISTS resource_object_id_mapping
(
    resource_id INTEGER NOT NULL,
    object_class INTEGER,
    sig_commons_object_id VARCHAR(80),
    resource_object_id VARCHAR(80),
    PRIMARY KEY(resource_id)
);


-- Create FKs
ALTER TABLE signature_components
    ADD    FOREIGN KEY (signature_id)
    REFERENCES signature(signature_id)
    MATCH SIMPLE
;
    
ALTER TABLE signature_components
    ADD    FOREIGN KEY (component_key)
    REFERENCES component_to_object(component_key)
    MATCH SIMPLE
;
    
ALTER TABLE probe_p100_to_protein
    ADD    FOREIGN KEY (probe_id)
    REFERENCES probe_p100(probe_id)
    MATCH SIMPLE
;
    
ALTER TABLE probe_p100_to_protein
    ADD    FOREIGN KEY (uniprot_accession)
    REFERENCES protein(uniprot_accession)
    MATCH SIMPLE
;
    
ALTER TABLE signature_to_object
    ADD    FOREIGN KEY (signature_id)
    REFERENCES signature(signature_id)
    MATCH SIMPLE
;
    
ALTER TABLE disease
    ADD    FOREIGN KEY (cell_line_id)
    REFERENCES cell_line(cell_line_id)
    MATCH SIMPLE
;
    
ALTER TABLE cell_line_synonym
    ADD    FOREIGN KEY (cell_line_id)
    REFERENCES cell_line(cell_line_id)
    MATCH SIMPLE
;
    
ALTER TABLE nucleic_acid_reagent
    ADD    FOREIGN KEY (entrez_gene_id)
    REFERENCES gene(entrez_gene_id)
    MATCH SIMPLE
;
    
ALTER TABLE signature_to_object
    ADD    FOREIGN KEY (signature_object_id)
    REFERENCES signature_object_to_meta(signature_object_id)
    MATCH SIMPLE
;
    
ALTER TABLE cell_line
    ADD    FOREIGN KEY (signature_object_id, signature_object_class)
    REFERENCES signature_object_to_meta(signature_object_id, signature_object_class)
    MATCH SIMPLE
;
    
ALTER TABLE perturbation
    ADD    FOREIGN KEY (signature_object_id, signature_object_class)
    REFERENCES signature_object_to_meta(signature_object_id, signature_object_class)
    MATCH SIMPLE
;
    
ALTER TABLE signature_provenance
    ADD    FOREIGN KEY (signature_object_id, signature_object_class)
    REFERENCES signature_object_to_meta(signature_object_id, signature_object_class)
    MATCH SIMPLE
;
    
ALTER TABLE signature_provenance
    ADD    FOREIGN KEY (resource_id)
    REFERENCES resource(resource_id)
    MATCH SIMPLE
;
    
ALTER TABLE small_molecule
    ADD    FOREIGN KEY (perturbagen_id, perturbagen_class)
    REFERENCES perturbation(perturbagen_id, perturbagen_class)
    MATCH SIMPLE
;
    
ALTER TABLE small_molecule_synonym
    ADD    FOREIGN KEY (perturbagen_id)
    REFERENCES small_molecule(perturbagen_id)
    MATCH SIMPLE
;
    
ALTER TABLE signature_provenance
    ADD    FOREIGN KEY (activity_id)
    REFERENCES generating_activity(activity_id)
    MATCH SIMPLE
;
    
ALTER TABLE component_to_object
    ADD    FOREIGN KEY (component_object_id)
    REFERENCES component_object_to_meta(component_object_id)
    MATCH SIMPLE
;
    
ALTER TABLE protein
    ADD    FOREIGN KEY (component_object_id, component_object_class)
    REFERENCES component_object_to_meta(component_object_id, component_object_class)
    MATCH SIMPLE
;
    
ALTER TABLE protein
    ADD    FOREIGN KEY (signature_object_id, signature_object_class)
    REFERENCES signature_object_to_meta(signature_object_id, signature_object_class)
    MATCH SIMPLE
;
    
ALTER TABLE probe_p100
    ADD    FOREIGN KEY (component_object_id, component_object_class)
    REFERENCES component_object_to_meta(component_object_id, component_object_class)
    MATCH SIMPLE
;
    
ALTER TABLE gene
    ADD    FOREIGN KEY (component_object_id, component_object_class)
    REFERENCES component_object_to_meta(component_object_id, component_object_class)
    MATCH SIMPLE
;

ALTER TABLE gene
    ADD    FOREIGN KEY (signature_object_id, signature_object_class)
    REFERENCES signature_object_to_meta(signature_object_id, signature_object_class)
    MATCH SIMPLE
;
    
ALTER TABLE nucleic_acid_reagent
    ADD    FOREIGN KEY (perturbagen_id, perturbagen_class)
    REFERENCES perturbation(perturbagen_id, perturbagen_class)
    MATCH SIMPLE
;
    
ALTER TABLE protein
    ADD    FOREIGN KEY (signature_object_id)
    REFERENCES signature_object_to_meta(signature_object_id)
    MATCH SIMPLE
;
    
ALTER TABLE resource_object_id_mapping
    ADD    FOREIGN KEY (resource_id)
    REFERENCES resource(resource_id)
    MATCH SIMPLE
;
    

-- Create Indexes

