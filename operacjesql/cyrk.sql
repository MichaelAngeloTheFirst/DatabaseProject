-- CREATE TABLE "treser"(
--     "treser_id" INTEGER NOT NULL,
--     "pseudonim" VARCHAR(255) NULL,
--     "nazwisko" VARCHAR(255) NOT NULL
-- );
-- ALTER TABLE
--     "treser" ADD PRIMARY KEY("treser_id");
-- CREATE TABLE "zwierze"(
--     "zwierze_id" INTEGER NOT NULL,
--     "gatunek" VARCHAR(255) NOT NULL,
--     "imie" VARCHAR(255) NOT NULL,
--     "treser_id" INTEGER NULL
-- );
-- ALTER TABLE
--     "zwierze" ADD PRIMARY KEY("zwierze_id");
-- CREATE TABLE "wystep"(
--     "wystep_id" INTEGER NOT NULL,
--     "lokalizacja" VARCHAR(255) NOT NULL,
--     "data" DATE NOT NULL
-- );
-- ALTER TABLE
--     "wystep" ADD PRIMARY KEY("wystep_id");
-- CREATE TABLE "terminarz"(
--     "terminarz_id" INTEGER NOT NULL,
--     "obsluga_id" INTEGER NULL,
--     "akrobata_id" INTEGER NULL,
--     "treser_id" INTEGER NULL,
--     "wystep_id" INTEGER NOT NULL
-- );
-- ALTER TABLE
--     "terminarz" ADD PRIMARY KEY("terminarz_id");
-- CREATE TABLE "akrobata"(
--     "akrobata_id" INTEGER NOT NULL,
--     "pseudonim" VARCHAR(255) NULL,
--     "nazwisko" VARCHAR(255) NOT NULL
-- );
-- ALTER TABLE
--     "akrobata" ADD PRIMARY KEY("akrobata_id");
-- CREATE TABLE "bilet"(
--     "bilet_id" INTEGER NOT NULL,
--     "cena" INTEGER NOT NULL,
--     "ilosc" INTEGER NOT NULL,
--     "typ" VARCHAR(255) CHECK
--         ("typ" IN('ulgowy','normalny','premium')) NOT NULL
-- );
-- ALTER TABLE
--     "bilet" ADD PRIMARY KEY("bilet_id");
-- CREATE TABLE "wystep_to_bilet_relation"(
--     "wystep_to_bilet_relation_id" INTEGER NOT NULL,
--     "wystep_id" INTEGER NOT NULL,
--     "bilet_id" INTEGER NOT NULL
-- );
-- ALTER TABLE
--     "wystep_to_bilet_relation" ADD PRIMARY KEY("wystep_to_bilet_relation_id");
-- CREATE TABLE "obsluga"(
--     "obsluga_id" INTEGER NOT NULL,
--     "nazwisko" VARCHAR(255) NOT NULL,
--     "zajecie" VARCHAR(255) NOT NULL
-- );
-- ALTER TABLE
--     "obsluga" ADD PRIMARY KEY("obsluga_id");
-- CREATE TABLE "smakolyk"(
--     "smakolyk_id" INTEGER NOT NULL,
--     "nazwa" VARCHAR(255) NOT NULL,
--     "cena" INTEGER NOT NULL,
--     "ilosc" INTEGER NOT NULL
-- );
-- ALTER TABLE
--     "smakolyk" ADD PRIMARY KEY("smakolyk_id");
-- CREATE TABLE "smakolyk_to_zwierze_relation"(
--     "smakolyk_to_zwierze_id" INTEGER NOT NULL,
--     "zwierze_id" INTEGER NOT NULL,
--     "smakolyk_id" INTEGER NOT NULL
-- );
-- ALTER TABLE
--     "smakolyk_to_zwierze_relation" ADD PRIMARY KEY("smakolyk_to_zwierze_id");
-- ALTER TABLE
--     "terminarz" ADD CONSTRAINT "terminarz_treser_id_foreign" FOREIGN KEY("treser_id") REFERENCES "treser"("treser_id");
-- ALTER TABLE
--     "zwierze" ADD CONSTRAINT "zwierze_treser_id_foreign" FOREIGN KEY("treser_id") REFERENCES "treser"("treser_id");
-- ALTER TABLE
--     "terminarz" ADD CONSTRAINT "terminarz_wystep_id_foreign" FOREIGN KEY("wystep_id") REFERENCES "wystep"("wystep_id");
-- ALTER TABLE
--     "wystep_to_bilet_relation" ADD CONSTRAINT "wystep_to_bilet_relation_wystep_id_foreign" FOREIGN KEY("wystep_id") REFERENCES "wystep"("wystep_id");
-- ALTER TABLE
--     "terminarz" ADD CONSTRAINT "terminarz_akrobata_id_foreign" FOREIGN KEY("akrobata_id") REFERENCES "akrobata"("akrobata_id");
-- ALTER TABLE
--     "wystep_to_bilet_relation" ADD CONSTRAINT "wystep_to_bilet_relation_bilet_id_foreign" FOREIGN KEY("bilet_id") REFERENCES "bilet"("bilet_id");
-- ALTER TABLE
--     "terminarz" ADD CONSTRAINT "terminarz_obsluga_id_foreign" FOREIGN KEY("obsluga_id") REFERENCES "obsluga"("obsluga_id");
-- ALTER TABLE
--     "smakolyk_to_zwierze_relation" ADD CONSTRAINT "smakolyk_to_zwierze_relation_smakolyk_id_foreign" FOREIGN KEY("smakolyk_id") REFERENCES "smakolyk"("smakolyk_id");
-- ALTER TABLE
--     "smakolyk_to_zwierze_relation" ADD CONSTRAINT "smakolyk_to_zwierze_relation_zwierze_id_foreign" FOREIGN KEY("zwierze_id") REFERENCES "zwierze"("zwierze_id");

CREATE TABLE "treser"(
    "treser_id" INTEGER NOT NULL,
    "pseudonim" VARCHAR(255) NULL,
    "nazwisko" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "treser" ADD PRIMARY KEY("treser_id");
CREATE TABLE "zwierze"(
    "zwierze_id" INTEGER NOT NULL,
    "gatunek" VARCHAR(255) NOT NULL,
    "imie" VARCHAR(255) NOT NULL,
    "treser_id" INTEGER NULL
);
ALTER TABLE
    "zwierze" ADD PRIMARY KEY("zwierze_id");
CREATE TABLE "wystep"(
    "wystep_id" INTEGER NOT NULL,
    "lokalizacja" VARCHAR(255) NOT NULL,
    "data" DATE NOT NULL
);
ALTER TABLE
    "wystep" ADD PRIMARY KEY("wystep_id");
CREATE TABLE "treser_to_wystep_relation"(
    "treser_to_wystep_relation_id" SERIAL NOT NULL,
    "treser_id" INTEGER NOT NULL,
    "wystep_id" INTEGER NOT NULL
);
ALTER TABLE
    "treser_to_wystep_relation" ADD PRIMARY KEY("treser_to_wystep_relation_id");
CREATE TABLE "akrobata"(
    "akrobata_id" INTEGER NOT NULL,
    "pseudonim" VARCHAR(255) NULL,
    "nazwisko" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "akrobata" ADD PRIMARY KEY("akrobata_id");
CREATE TABLE "bilet"(
    "bilet_id" INTEGER NOT NULL,
    "cena" INTEGER NOT NULL,
    "ilosc" INTEGER NOT NULL,
    "typ" VARCHAR(255) CHECK
        ("typ" IN('ulgowy','normalny','premium')) NOT NULL
);
ALTER TABLE
    "bilet" ADD PRIMARY KEY("bilet_id");
CREATE TABLE "wystep_to_bilet_relation"(
    "wystep_to_bilet_relation_id" SERIAL NOT NULL,
    "wystep_id" INTEGER NOT NULL,
    "bilet_id" INTEGER NOT NULL
);
ALTER TABLE
    "wystep_to_bilet_relation" ADD PRIMARY KEY("wystep_to_bilet_relation_id");
CREATE TABLE "obsluga"(
    "obsluga_id" INTEGER NOT NULL,
    "nazwisko" VARCHAR(255) NOT NULL,
    "zajecie" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "obsluga" ADD PRIMARY KEY("obsluga_id");
CREATE TABLE "smakolyk"(
    "smakolyk_id" INTEGER NOT NULL,
    "nazwa" VARCHAR(255) NOT NULL,
    "cena" INTEGER NOT NULL
);
ALTER TABLE
    "smakolyk" ADD PRIMARY KEY("smakolyk_id");
CREATE TABLE "smakolyk_to_zwierze_relation"(
    "smakolyk_to_zwierze_id" INTEGER NOT NULL,
    "zwierze_id" INTEGER NOT NULL,
    "smakolyk_id" INTEGER NOT NULL
);
ALTER TABLE
    "smakolyk_to_zwierze_relation" ADD PRIMARY KEY("smakolyk_to_zwierze_id");
CREATE TABLE "obsluga_to_wystep_relation"(
    "obsluga_to_wystep_relation_id" SERIAL NOT NULL,
    "obsluga_id" INTEGER NOT NULL,
    "wystep_id" INTEGER NOT NULL
);
ALTER TABLE
    "obsluga_to_wystep_relation" ADD PRIMARY KEY("obsluga_to_wystep_relation_id");
CREATE TABLE "akrobata_to_wystep_relation"(
    "akrobata_to_wystep_relation_id" SERIAL NOT NULL,
    "akrobata_id" INTEGER NOT NULL,
    "wystep_id" INTEGER NOT NULL
);
ALTER TABLE
    "akrobata_to_wystep_relation" ADD PRIMARY KEY("akrobata_to_wystep_relation_id");
ALTER TABLE
    "treser_to_wystep_relation" ADD CONSTRAINT "treser_to_wystep_relation_treser_id_foreign" FOREIGN KEY("treser_id") REFERENCES "treser"("treser_id");
ALTER TABLE
    "zwierze" ADD CONSTRAINT "zwierze_treser_id_foreign" FOREIGN KEY("treser_id") REFERENCES "treser"("treser_id");
ALTER TABLE
    "treser_to_wystep_relation" ADD CONSTRAINT "treser_to_wystep_relation_wystep_id_foreign" FOREIGN KEY("wystep_id") REFERENCES "wystep"("wystep_id");
ALTER TABLE
    "wystep_to_bilet_relation" ADD CONSTRAINT "wystep_to_bilet_relation_wystep_id_foreign" FOREIGN KEY("wystep_id") REFERENCES "wystep"("wystep_id");
ALTER TABLE
    "akrobata_to_wystep_relation" ADD CONSTRAINT "akrobata_to_wystep_relation_wystep_id_foreign" FOREIGN KEY("wystep_id") REFERENCES "wystep"("wystep_id");
ALTER TABLE
    "obsluga_to_wystep_relation" ADD CONSTRAINT "obsluga_to_wystep_relation_wystep_id_foreign" FOREIGN KEY("wystep_id") REFERENCES "wystep"("wystep_id");
ALTER TABLE
    "akrobata_to_wystep_relation" ADD CONSTRAINT "akrobata_to_wystep_relation_akrobata_id_foreign" FOREIGN KEY("akrobata_id") REFERENCES "akrobata"("akrobata_id");
ALTER TABLE
    "wystep_to_bilet_relation" ADD CONSTRAINT "wystep_to_bilet_relation_bilet_id_foreign" FOREIGN KEY("bilet_id") REFERENCES "bilet"("bilet_id");
ALTER TABLE
    "obsluga_to_wystep_relation" ADD CONSTRAINT "obsluga_to_wystep_relation_obsluga_id_foreign" FOREIGN KEY("obsluga_id") REFERENCES "obsluga"("obsluga_id");
ALTER TABLE
    "smakolyk_to_zwierze_relation" ADD CONSTRAINT "smakolyk_to_zwierze_relation_smakolyk_id_foreign" FOREIGN KEY("smakolyk_id") REFERENCES "smakolyk"("smakolyk_id");
ALTER TABLE
    "smakolyk_to_zwierze_relation" ADD CONSTRAINT "smakolyk_to_zwierze_relation_zwierze_id_foreign" FOREIGN KEY("zwierze_id") REFERENCES "zwierze"("zwierze_id");