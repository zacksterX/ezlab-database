CREATE TABLE public.books
(
    id serial NOT NULL,
    author text,
    book_name text,
    pages int,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.books
    OWNER to postgres;

