set client_min_messages to warning;

-- DANGER: this is NOT how to do it in the real world.
-- `drop schema` INSTANTLY ERASES EVERYTHING.
drop schema "public" cascade;

create schema "public";

CREATE TABLE public.fighters(
  "fighterId" SERIAL NOT NULL,
  "fighter" TEXT NOT NULL,
  "rosterId" VARCHAR NOT NULL,
  "displayName" TEXT NOT NULL,
  "createdAt" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  PRIMARY KEY("fighterId")
);


CREATE TABLE public.moves(
  "moveId" SERIAL NOT NULL,
  "fighterId" INT REFERENCES public.fighters,
  "name" TEXT NOT NULL,
  "moveType" TEXT,
  "createdAt" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  PRIMARY KEY("moveId")
);

CREATE TABLE public.hitboxes(
  "moveId" SERIAL REFERENCES public.moves,
  "damage" TEXT,
  "activeFrames" TEXT,
  "totalFrames" TEXT,
  "createdAt" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  PRIMARY KEY("moveId")
);



-- INSERT INTO/DATA SECTION

INSERT INTO public.fighters ("fighter", "rosterId", "displayName")
  VALUES
    ('banjo', '73', 'banjo & kazooie'),
    ('bayonetta', '63', 'bayonetta'),
    ('inkling', '64', 'inkling'),
    ('joker', '71', 'joker');

INSERT INTO public.moves AS "banjo"
  ("fighterId", "name", "moveType")
  VALUES
    (1, 'jab 1', 'single'),
    (1, 'jab 2', 'single'),
    (1, 'jab 3', 'single'),
    (1, 'rapid jab', 'multi'),
    (1, 'rapid jab finisher', 'single'),
    (1, 'forward tilt', 'tipper/close'),
    (1, 'up tilt', 'single'),
    (1, 'down tilt', 'tipper/close/late'),
    (1, 'dash attack', 'early/late'),
    (1, 'forward smash', 'single'),
    (1, 'up smash', 'first/multi/final'),
    (1, 'down smash', 'single'),
    (1, 'neutral air', 'multi/final'),
    (1, 'forward air', 'early/late'),
    (1, 'back air', 'multi/final'),
    (1, 'up air', 'first/second'),
    (1, 'down air', 'falling/landing'),
    (1, 'neutral special', 'early/late/latest'),
    (1, 'side special', 'early/late'),
    (1, 'up special', '(charged)'),
    (1, 'down special', 'contact/explosion');

INSERT INTO public.hitboxes AS "banjo"
  ("damage", "activeFrames", "totalFrames")
  VALUES
    ('2.2%', '4-6', '27'),
    ('2.2%', '4-6', '24'),
    ('3.8%', '5-7', '31'),
    ('0.4%', '5 [rehit: 2]', null),
    ('1.6%', '7-8', '41'),
    ('9.0/7.0%', '7-9', '28'),
    ('10.0%', '11-14', '31'),
    ('6.0/5.0/4.0%', '12-17/18-21', '37'),
    ('12.0/8.0%', '9-12/13-20', '36'),
    ('16.0%', '19-21', '52'),
    ('1.0/1.5/3.6%', '9-10/13-25 [rehit: 2]/26-27', '65'),
    ('15.0%', '13-17', '46'),
    ('0.8/4.2%', '10-11(13-14/16-17..)/31-32', '47'),
    ('15.0/12.0%', '15-17/18', '51'),
    ('1.6/4.8%', '8-9/12-13/16-17', '43'),
    ('1.6/5.8%', '7-8/9-11', '33'),
    ('10.0/2.0%', '15-45/1-2', '56'),
    ('5.4/4.6/3.8%', '13-22/23-52/53-102', '49'),
    ('22.0/16.0%', '18-35/36-53', '82'),
    ('3.0%', '15(31)', '58'),
    ('0.5/8.5%', '10-143', '44');

INSERT INTO public.moves AS "bayonetta"
  ("fighterId", "name", "moveType")
  VALUES
    (2, 'jab 1', 'single'),
    (2, 'jab 2', 'single'),
    (2, 'jab 3', 'single'),
    (2, 'rapid jab', 'single/multi'),
    (2, 'rapid jab finisher', 'single'),
    (2, 'forward tilt 1', 'single'),
    (2, 'forward tilt 2', 'single'),
    (2, 'forward tilt 3', 'single'),
    (2, 'up tilt', 'single/single/final'),
    (2, 'down tilt', 'close/tipper'),
    (2, 'dash attack', 'early/late'),
    (2, 'forward smash', 'tipper/close'),
    (2, 'up smash', 'early/late/latest'),
    (2, 'down smash', 'stomp/early/late'),
    (2, 'neutral air', 'early/late/(extended)'),
    (2, 'forward air 1', 'single'),
    (2, 'forward air 2', 'single'),
    (2, 'forward air 3', 'single'),
    (2, 'back air', 'tipper/close'),
    (2, 'up air', 'single/(extended)'),
    (2, 'down air', 'closest/close/tipper/landing'),
    (2, 'neutral special', 'multi'),
    (2, 'neutral special (charged)', 'multi'),
    -- (2, 'side special (ground)', 'early/late'),
    (2, 'afterburner kick, up', 'early/late/latest'),
    (2, 'afterburner kick, down', 'normal/landing'),
    (2, 'up special', 'first/multi/final'),
    (2, 'down special', 'counter');

INSERT INTO public.hitboxes AS "bayonetta"
  ("damage", "activeFrames", "totalFrames")
  VALUES
    ('1.4%', '9-12', '31'),
    ('1.4%', '7-8', '31'),
    ('2.2%', '7-8', '39'),
    ('0.5/0.2%', '6 [rehit: 4]', null),
    ('5.0%', '4-5/11-12', '62'),
    ('3.0%', '12', '31'),
    ('3.0%', '12', '39'),
    ('7.0%', '14-15', '39'),
    ('1.5/6.0%', '7-9/10-12/13-15', '31'),
    ('5.0/6.0%', '7-8', '28'),
    ('10.0/8.0%', '15-20/21-26', '42'),
    ('16.0/14.0%', '17-21', '66'),
    ('17.0/16.0/15.0%', '18-19/20-21/22-23', '64'),
    ('15.0%', '17-18/22/23-25', '65'),
    ('8.0/6.0/3.0%', '9-17/18-25 (26-66)', '32'),
    ('4.0%', '7-9', '37'),
    ('3.3%', '7-9', '39'),
    ('7.0%', '12-15', '46'),
    ('13.0/10.0%', '11-14', '34'),
    ('7.5/3.0%', '9-18 (21-65)', '29'),
    ('7.0/8.0/9.0/5.0%', '18-35/1-2', '52'),
    ('1.3%', '17-26/22-31/32-41/37-46..', '75'),
    ('2.7%', '42/47/57/62..', '100'),
    -- ('8.0/7.0/5.0%', '15-16', '82'),
    ('6.0/7.0/6.0%', '7-9/10-14/15-19', '31'),
    ('6.5/5.0%', '8-25/1', '43'),
    ('3.0/0.2/3.0%', '6/11-25 [rehit: 3]/27-28', '31'),
    (null, '8-27', '66');

INSERT INTO public.moves AS "inkling"
  ("fighterId", "name", "moveType")
  VALUES
    (3, 'jab 1', 'single'),
    (3, 'jab 2', 'single'),
    (3, 'jab 3', 'single'),
    (3, 'rapid jab', 'multi'),
    (3, 'rapid jab finisher', 'single'),
    (3, 'forward tilt', 'single'),
    (3, 'up tilt', 'single'),
    (3, 'down tilt', 'first/second'),
    (3, 'dash attack', 'early/late'),
    (3, 'forward smash', 'close/tipper'),
    (3, 'up smash', 'first/close/far'),
    (3, 'down smash', '(front)(back)'),
    (3, 'neutral air', 'single'),
    (3, 'forward air', 'tipper/early/late'),
    (3, 'back air', 'tipper/close'),
    (3, 'up air', 'first/second'),
    (3, 'down air', 'tipper/close'),
    (3, 'neutral special', 'multi'),
    (3, 'side special', 'air/grounded'),
    (3, 'up special', 'grounded/air/landing'),
    (3, 'down special', 'charge');

INSERT INTO public.hitboxes AS "inkling"
  ("damage", "activeFrames", "totalFrames")
  VALUES
    ('2.0%', '3-4', '19'),
    ('2.0%', '2-3', '21'),
    ('3.5%', '4-5', '29'),
    ('0.4%', '4 [rehit: 3]', null),
    ('9.0%', '6', '48'),
    ('6.0%', '8-10', '34'),
    ('6.0%', '7-12', '29'),
    ('3.0/6.0%', '5-8/12-15', '31'),
    ('8.9/6.0%', '6', '48'),
    ('14.0/16.0%', '16-17', '51'),
    ('4.0/15.0/10.0%', '9-10/18-20', '57'),
    ('12.5/11.0%', '(11-12/13-15)(20-21/22-24)', '49'),
    ('7.0%', '6-9', '31'),
    ('12.0/10.0/7.0%', '10-11/12-21', '41'),
    ('10.0/7.5%', '7-11', '36'),
    ('4.5/6.5%', '12-15/17-20', '43'),
    ('12.0/10.0%', '16-17', '61'),
    ('0.3%', '16 [rehit: 4]', '36'),
    ('4.0-11.0%', '16+', '17/35'),
    ('8.0/6.0%', '12/15-21/1-10', '40'),
    ('9.4-15.0%', '20-159', '47-65');

INSERT INTO public.moves AS "joker"
  ("fighterId", "name", "moveType")
  VALUES
    (4, 'jab 1', 'single (arsene)'),
    (4, 'jab 2', 'single (arsene)'),
    (4, 'jab 3', 'single (arsene)'),
    (4, 'rapid jab', null),
    (4, 'rapid jab finisher', null),
    (4, 'forward tilt', 'first/second (arsene)'),
    (4, 'up tilt', 'first/multi/final'),
    (4, 'down tilt', 'late/early'),
    (4, 'dash attack', 'first/second'),
    (4, 'forward smash', 'single'),
    (4, 'up smash', 'single'),
    (4, 'down smash', 'front/back'),
    (4, 'neutral air', 'single (front/back)'),
    (4, 'forward air', 'first/second'),
    (4, 'back air', 'single'),
    (4, 'up air', 'multi/final'),
    (4, 'down air', 'single (Arsene: first/second'),
    (4, 'neutral b', 'close/med/far'),
    (4, 'side b', 'contact/erupt'),
    (4, 'side b, arsene', 'contact/erupt'),
    (4, 'up b (grappling hook)', 'recovery'),
    (4, 'up b (grappling attack)', 'grounded/air');
--     ('down b', 'minimal/additional endlag'),
--     ('down b', 'minimal/additional endlag'),
--     ('down b', 'minimal/additional endlag'),
--     ('down b', 'minimal/additional endlag');

INSERT INTO public.hitboxes AS "joker"
  ("damage", "activeFrames", "totalFrames")
  VALUES
    ('2.0 (2.7)%', '4-5(4-5)', '23'),
    ('1.5 (2.2)%', '3-4(3-4)', '23'),
    ('4.0 (7.1)%', '3-4', '34'),
    (null, null, null),
    (null, null, null),
    ('3.0/5.0 (3.0/10.0)%', '8-9/13-15(8-9/13-19)', '34'),
    ('4.0/1.0/1.0 (4.0/1.7/3.9)%', '8-9/11-19/20-23', '40'),
    ('6.0/(13.0)%', '8-9/10-11/12-14', '37'),
    ('2.0/6.0 (2.0/12.0)%', '6-7/15-21', '45'),
    ('14.0 (22.0)%', '16-18(16-19)', '47'),
    ('12.0 (17.0)%', '10-14', '51'),
    ('12.0 (18.0)%', '12-13/16-17', '51'),
    ('7.0 (7.0/4.0)%', '12-27', '54'),
    ('2.0/5.0 (2.0/13.0)%', '7-8/12-14', '47'),
    ('9.0 (16.0)%', '7-8', '31'),
    ('0.7/3.0 (0.7/10.0)%', '5-18 [rehit: 3]/20-21', '39'),
    ('8.0 (8.0/8.0)%', '13-16 (13-16/15-16)', '46'),
    ('5.0/3.0/1.0%', '12/37/65..', '36/61/92'),
    ('1.0/2.0% [rehit: 1%]', '16-42/1-19 [rehit: 45]', '52'),
    ('1.0/2.0% [rehit: 1%]', '16-32 (1-15/16-27) [rehit: 45]', '52'),
    (null, '20-26', '59/44'),
    ('11.0/5.0%', '5', '28')
    -- (null, '3+', '52/33'),
    -- (null, '3+', '52/33'),
    -- (null, '3+', '52/33'),
    -- (null, '3+', '52/33')
