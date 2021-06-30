start transaction;

INSERT INTO Cliente (codice_fiscale, nome, cognome, telefono)
VALUES
('BZWLGX32S28A742I',    'francesco',    'rossi',    '0000000000'),
('WXKPHP62P13I422Q',    'alberto',      'verdi',    '1111111111'),
('RDPCZW50H52C879U',    'luca',         'gialli',   '2222222222'),
('FFNMPM29E19G365M',    'massimiliano', 'aranci',   '3333333333'),
('JVUMFA71C62I606Z',    'ludovico',     'neri',     '4444444444');

commit;