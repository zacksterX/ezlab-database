CREATE TABLE public.users
(
    id serial NOT NULL,
    full_name character varying(150) NOT NULL,
    age integer NOT NULL,
    address text,
    passport character varying(10) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (passport),
    CHECK (age > 0 and age <= 130) NOT VALID
);

ALTER TABLE IF EXISTS public.users
    OWNER to postgres;

