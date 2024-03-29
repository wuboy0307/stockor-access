--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

--
-- Name: skr_next_sequential_id(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION skr_next_sequential_id(character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
    next_id integer;
begin
    select current_value into next_id from skr_sequential_ids where name = $1 for update;
    if not found then
        insert into skr_sequential_ids ( name, current_value ) values ( $1, 1 );
        return 1;
    else
        update skr_sequential_ids set current_value = next_id+1 where name = $1;
        return next_id+1;
    end if;
end;
$_$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: skr_addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_addresses (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    phone character varying(255),
    line1 character varying(255),
    line2 character varying(255),
    city character varying(255),
    state character varying(255),
    postal_code character varying(255),
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_addresses_id_seq OWNED BY skr_addresses.id;


--
-- Name: skr_customers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_customers (
    id integer NOT NULL,
    code character varying(255) NOT NULL,
    billing_address_id integer NOT NULL,
    shipping_address_id integer NOT NULL,
    terms_id integer NOT NULL,
    gl_receivables_account_id integer NOT NULL,
    credit_limit numeric(15,2) DEFAULT 0.0,
    open_balance numeric(15,2) DEFAULT 0.0,
    hash_code character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    notes text,
    website text,
    options hstore DEFAULT ''::hstore,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_customers_id_seq OWNED BY skr_customers.id;


--
-- Name: skr_gl_accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_gl_accounts (
    id integer NOT NULL,
    number character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_gl_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_gl_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_gl_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_gl_accounts_id_seq OWNED BY skr_gl_accounts.id;


--
-- Name: skr_gl_manual_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_gl_manual_entries (
    id integer NOT NULL,
    visible_id integer NOT NULL,
    notes text,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_gl_manual_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_gl_manual_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_gl_manual_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_gl_manual_entries_id_seq OWNED BY skr_gl_manual_entries.id;


--
-- Name: skr_gl_periods; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_gl_periods (
    id integer NOT NULL,
    year smallint NOT NULL,
    period smallint NOT NULL,
    is_locked boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_gl_periods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_gl_periods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_gl_periods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_gl_periods_id_seq OWNED BY skr_gl_periods.id;


--
-- Name: skr_gl_postings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_gl_postings (
    id integer NOT NULL,
    gl_transaction_id integer NOT NULL,
    account_number character varying(255) NOT NULL,
    amount numeric(15,2) NOT NULL,
    is_debit boolean NOT NULL,
    year smallint NOT NULL,
    period smallint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL
);


--
-- Name: skr_gl_postings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_gl_postings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_gl_postings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_gl_postings_id_seq OWNED BY skr_gl_postings.id;


--
-- Name: skr_gl_transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_gl_transactions (
    id integer NOT NULL,
    period_id integer NOT NULL,
    source_id integer,
    source_type character varying(255),
    description text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL
);


--
-- Name: skr_gl_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_gl_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_gl_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_gl_transactions_id_seq OWNED BY skr_gl_transactions.id;


--
-- Name: skr_ia_lines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_ia_lines (
    id integer NOT NULL,
    inventory_adjustment_id integer NOT NULL,
    sku_loc_id integer NOT NULL,
    qty integer DEFAULT 1 NOT NULL,
    uom_code character varying(255) DEFAULT 'EA'::character varying NOT NULL,
    uom_size smallint DEFAULT 1 NOT NULL,
    cost numeric(15,2),
    cost_was_set boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_ia_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_ia_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_ia_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_ia_lines_id_seq OWNED BY skr_ia_lines.id;


--
-- Name: skr_ia_reasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_ia_reasons (
    id integer NOT NULL,
    gl_account_id integer NOT NULL,
    code character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_ia_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_ia_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_ia_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_ia_reasons_id_seq OWNED BY skr_ia_reasons.id;


--
-- Name: skr_inv_lines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_inv_lines (
    id integer NOT NULL,
    invoice_id integer NOT NULL,
    sku_loc_id integer NOT NULL,
    pt_line_id integer,
    so_line_id integer,
    price numeric(15,2) NOT NULL,
    sku_code character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    uom_code character varying(255) NOT NULL,
    uom_size smallint NOT NULL,
    "position" smallint NOT NULL,
    qty integer NOT NULL,
    is_revised boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_invoices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_invoices (
    id integer NOT NULL,
    visible_id integer NOT NULL,
    terms_id integer NOT NULL,
    customer_id integer NOT NULL,
    location_id integer NOT NULL,
    sales_order_id integer,
    pick_ticket_id integer,
    shipping_address_id integer NOT NULL,
    billing_address_id integer NOT NULL,
    amount_paid numeric(15,2) DEFAULT 0.0 NOT NULL,
    state character varying(255) NOT NULL,
    hash_code character varying(255) NOT NULL,
    invoice_date date NOT NULL,
    po_num character varying(255),
    options hstore DEFAULT ''::hstore,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_pick_tickets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_pick_tickets (
    id integer NOT NULL,
    visible_id integer NOT NULL,
    sales_order_id integer NOT NULL,
    location_id integer NOT NULL,
    shipped_at date,
    is_complete boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_sales_orders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_sales_orders (
    id integer NOT NULL,
    visible_id integer NOT NULL,
    customer_id integer NOT NULL,
    location_id integer NOT NULL,
    shipping_address_id integer NOT NULL,
    billing_address_id integer NOT NULL,
    terms_id integer NOT NULL,
    order_date date NOT NULL,
    state character varying(255) NOT NULL,
    is_revised boolean DEFAULT false NOT NULL,
    hash_code character varying(255) NOT NULL,
    ship_partial boolean DEFAULT false NOT NULL,
    is_complete boolean DEFAULT false NOT NULL,
    po_num character varying(255),
    notes text,
    options hstore DEFAULT ''::hstore,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_sku_locs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_sku_locs (
    id integer NOT NULL,
    sku_id integer NOT NULL,
    location_id integer NOT NULL,
    mac numeric(15,4) DEFAULT 0.0 NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    qty_allocated integer DEFAULT 0 NOT NULL,
    qty_picking integer DEFAULT 0 NOT NULL,
    qty_reserved integer DEFAULT 0 NOT NULL,
    bin character varying(255),
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_skus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_skus (
    id integer NOT NULL,
    default_vendor_id integer NOT NULL,
    gl_asset_account_id integer NOT NULL,
    default_uom_code character varying(255) NOT NULL,
    code character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    is_other_charge boolean DEFAULT false NOT NULL,
    does_track_inventory boolean DEFAULT false NOT NULL,
    can_backorder boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_inv_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_inv_details AS
    SELECT inv.id AS invoice_id, so.visible_id AS sales_order_visible_id, pt.id AS pick_ticket_id, to_char(so.created_at, 'YYYY-MM-DD'::text) AS string_order_date, to_char(inv.created_at, 'YYYY-MM-DD'::text) AS string_invoice_date, cust.code AS customer_code, cust.name AS customer_name, ba.name AS bill_addr_name, COALESCE(ttls.total, 0.0) AS total, COALESCE(ttls.num_lines, (0)::bigint) AS num_lines, COALESCE(ttls.other_charge_total, (0)::numeric) AS total_other_charge_amount, (COALESCE(ttls.total, 0.0) - COALESCE(ttls.other_charge_total, 0.0)) AS subtotal_amount FROM (((((skr_invoices inv JOIN skr_customers cust ON ((cust.id = inv.customer_id))) LEFT JOIN skr_addresses ba ON ((ba.id = inv.billing_address_id))) LEFT JOIN skr_sales_orders so ON ((so.id = inv.sales_order_id))) LEFT JOIN skr_pick_tickets pt ON ((pt.id = inv.pick_ticket_id))) LEFT JOIN (SELECT ivl.invoice_id, sum(((ivl.qty)::numeric * ivl.price)) AS total, sum(CASE WHEN s.is_other_charge THEN ((ivl.qty)::numeric * ivl.price) ELSE (0)::numeric END) AS other_charge_total, count(ivl.*) AS num_lines FROM ((skr_inv_lines ivl JOIN skr_sku_locs sl ON ((sl.id = ivl.sku_loc_id))) JOIN skr_skus s ON ((s.id = sl.sku_id))) GROUP BY ivl.invoice_id) ttls ON ((ttls.invoice_id = inv.id)));


--
-- Name: skr_inv_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_inv_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_inv_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_inv_lines_id_seq OWNED BY skr_inv_lines.id;


--
-- Name: skr_inventory_adjustments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_inventory_adjustments (
    id integer NOT NULL,
    visible_id integer NOT NULL,
    location_id integer NOT NULL,
    reason_id integer NOT NULL,
    state character varying(255) NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_inventory_adjustments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_inventory_adjustments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_inventory_adjustments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_inventory_adjustments_id_seq OWNED BY skr_inventory_adjustments.id;


--
-- Name: skr_invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_invoices_id_seq OWNED BY skr_invoices.id;


--
-- Name: skr_locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_locations (
    id integer NOT NULL,
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    address_id integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    gl_branch_code character varying(2) DEFAULT '01'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_locations_id_seq OWNED BY skr_locations.id;


--
-- Name: skr_payment_terms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_payment_terms (
    id integer NOT NULL,
    code character varying(255) NOT NULL,
    days integer DEFAULT 0 NOT NULL,
    description character varying(255) NOT NULL,
    discount_days integer,
    discount_amount character varying(255),
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_payment_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_payment_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_payment_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_payment_terms_id_seq OWNED BY skr_payment_terms.id;


--
-- Name: skr_pick_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_pick_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_pick_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_pick_tickets_id_seq OWNED BY skr_pick_tickets.id;


--
-- Name: skr_po_lines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_po_lines (
    id integer NOT NULL,
    purchase_order_id integer NOT NULL,
    sku_loc_id integer NOT NULL,
    sku_vendor_id integer NOT NULL,
    part_code character varying(255) NOT NULL,
    sku_code character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    uom_code character varying(255) NOT NULL,
    uom_size smallint NOT NULL,
    "position" smallint NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    qty_received integer DEFAULT 0 NOT NULL,
    qty_canceled integer DEFAULT 0 NOT NULL,
    price numeric(15,2) NOT NULL,
    is_revised boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_po_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_po_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_po_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_po_lines_id_seq OWNED BY skr_po_lines.id;


--
-- Name: skr_po_receipts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_po_receipts (
    id integer NOT NULL,
    visible_id integer NOT NULL,
    location_id integer NOT NULL,
    freight numeric(15,2) DEFAULT 0.0 NOT NULL,
    purchase_order_id integer NOT NULL,
    vendor_id integer NOT NULL,
    voucher_id integer,
    refno character varying(255),
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL
);


--
-- Name: skr_po_receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_po_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_po_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_po_receipts_id_seq OWNED BY skr_po_receipts.id;


--
-- Name: skr_por_lines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_por_lines (
    id integer NOT NULL,
    po_receipt_id integer NOT NULL,
    po_line_id integer,
    sku_loc_id integer NOT NULL,
    sku_vendor_id integer,
    sku_code character varying(255) NOT NULL,
    part_code character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    uom_code character varying(255) NOT NULL,
    uom_size smallint NOT NULL,
    "position" smallint NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    price numeric(15,2) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL
);


--
-- Name: skr_por_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_por_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_por_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_por_lines_id_seq OWNED BY skr_por_lines.id;


--
-- Name: skr_pt_lines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_pt_lines (
    id integer NOT NULL,
    pick_ticket_id integer NOT NULL,
    so_line_id integer NOT NULL,
    sku_loc_id integer NOT NULL,
    price numeric(15,2) NOT NULL,
    sku_code character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    uom_code character varying(255) NOT NULL,
    bin character varying(255),
    uom_size smallint NOT NULL,
    "position" smallint NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    qty_invoiced integer DEFAULT 0 NOT NULL,
    is_complete boolean DEFAULT false NOT NULL
);


--
-- Name: skr_pt_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_pt_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_pt_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_pt_lines_id_seq OWNED BY skr_pt_lines.id;


--
-- Name: skr_purchase_orders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_purchase_orders (
    id integer NOT NULL,
    visible_id integer NOT NULL,
    vendor_id integer NOT NULL,
    location_id integer NOT NULL,
    ship_addr_id integer NOT NULL,
    terms_id integer NOT NULL,
    state character varying(255) NOT NULL,
    is_revised boolean DEFAULT false NOT NULL,
    order_date date NOT NULL,
    receiving_completed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_purchase_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_purchase_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_purchase_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_purchase_orders_id_seq OWNED BY skr_purchase_orders.id;


--
-- Name: skr_sales_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_sales_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_sales_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_sales_orders_id_seq OWNED BY skr_sales_orders.id;


--
-- Name: skr_sequential_ids; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_sequential_ids (
    name character varying(255) NOT NULL,
    current_value integer DEFAULT 0 NOT NULL
);


--
-- Name: skr_sku_vendors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_sku_vendors (
    id integer NOT NULL,
    sku_id integer NOT NULL,
    vendor_id integer NOT NULL,
    list_price numeric(15,2) NOT NULL,
    part_code character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    uom_size integer DEFAULT 1 NOT NULL,
    uom_code character varying(255) DEFAULT 'EA'::character varying NOT NULL,
    cost numeric(15,2) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_uoms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_uoms (
    id integer NOT NULL,
    sku_id integer NOT NULL,
    price numeric(15,2) NOT NULL,
    size smallint DEFAULT 1 NOT NULL,
    code character varying(255) DEFAULT 'EA'::character varying NOT NULL,
    weight numeric(6,1),
    height numeric(6,1),
    width numeric(6,1),
    depth numeric(6,1),
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_vendors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_vendors (
    id integer NOT NULL,
    billing_address_id integer NOT NULL,
    shipping_address_id integer NOT NULL,
    terms_id integer NOT NULL,
    gl_payables_account_id integer NOT NULL,
    gl_freight_account_id integer NOT NULL,
    code character varying(255) NOT NULL,
    hash_code character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    notes text,
    account_code character varying(255),
    website character varying(255),
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_sku_loc_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_sku_loc_details AS
    SELECT sl.id AS sku_loc_id, s.code AS sku_code, s.description AS sku_description, s.default_uom_code, uom.id AS default_uom_id, COALESCE((uom.size)::integer, 1) AS default_uom_size, COALESCE(uom.price, 0.0) AS default_price, v.code AS vendor_code, v.name AS vendor_name, sv.part_code AS vendor_part_code, sv.cost AS purchase_cost FROM ((((skr_sku_locs sl JOIN skr_skus s ON ((s.id = sl.sku_id))) LEFT JOIN skr_uoms uom ON (((uom.sku_id = s.id) AND ((uom.code)::text = (s.default_uom_code)::text)))) JOIN skr_vendors v ON ((s.default_vendor_id = v.id))) JOIN skr_sku_vendors sv ON (((sv.vendor_id = v.id) AND (sv.sku_id = s.id))));


--
-- Name: skr_sku_locs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_sku_locs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_sku_locs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_sku_locs_id_seq OWNED BY skr_sku_locs.id;


--
-- Name: skr_so_lines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_so_lines (
    id integer NOT NULL,
    sales_order_id integer NOT NULL,
    sku_loc_id integer NOT NULL,
    price numeric(15,2) NOT NULL,
    sku_code character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    uom_code character varying(255) NOT NULL,
    uom_size smallint NOT NULL,
    "position" smallint NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    qty_allocated integer DEFAULT 0 NOT NULL,
    qty_picking integer DEFAULT 0 NOT NULL,
    qty_invoiced integer DEFAULT 0 NOT NULL,
    qty_canceled integer DEFAULT 0 NOT NULL,
    is_revised boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_sku_qty_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_sku_qty_details AS
    SELECT s.id AS sku_id, sl_ttl.qty AS qty_on_hand, COALESCE(sol_ttl.qty, (0)::bigint) AS qty_on_orders, COALESCE(pol_ttl.qty, (0)::bigint) AS qty_incoming FROM (((skr_skus s JOIN (SELECT sum(sl.qty) AS qty, sl.sku_id FROM skr_sku_locs sl GROUP BY sl.sku_id) sl_ttl ON ((sl_ttl.sku_id = s.id))) LEFT JOIN (SELECT s.id AS sku_id, sum(((sol.qty - sol.qty_canceled) * sol.uom_size)) AS qty FROM (((skr_so_lines sol JOIN skr_sales_orders so ON (((so.id = sol.sales_order_id) AND ((so.state)::text <> ALL ((ARRAY['canceled'::character varying, 'complete'::character varying])::text[]))))) JOIN skr_sku_locs sl ON ((sl.id = sol.sku_loc_id))) JOIN skr_skus s ON ((s.id = sl.sku_id))) GROUP BY s.id) sol_ttl ON ((sol_ttl.sku_id = s.id))) LEFT JOIN (SELECT s.id AS sku_id, sum(((pol.qty - pol.qty_canceled) * pol.uom_size)) AS qty FROM (((skr_po_lines pol JOIN skr_purchase_orders po ON (((po.id = pol.purchase_order_id) AND ((po.state)::text <> ALL ((ARRAY['canceled'::character varying, 'complete'::character varying])::text[]))))) JOIN skr_sku_locs sl ON ((sl.id = pol.sku_loc_id))) JOIN skr_skus s ON ((s.id = sl.sku_id))) GROUP BY s.id) pol_ttl ON ((pol_ttl.sku_id = s.id)));


--
-- Name: skr_sku_trans; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_sku_trans (
    id integer NOT NULL,
    origin_id integer,
    origin_type character varying(255),
    sku_loc_id integer NOT NULL,
    cost numeric(15,2) NOT NULL,
    origin_description character varying(255) NOT NULL,
    prior_qty integer NOT NULL,
    mac numeric(15,4) NOT NULL,
    prior_mac numeric(15,4) NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    uom_code character varying(255) DEFAULT 'EA'::character varying NOT NULL,
    uom_size integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL
);


--
-- Name: skr_sku_trans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_sku_trans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_sku_trans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_sku_trans_id_seq OWNED BY skr_sku_trans.id;


--
-- Name: skr_sku_vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_sku_vendors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_sku_vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_sku_vendors_id_seq OWNED BY skr_sku_vendors.id;


--
-- Name: skr_skus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_skus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_skus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_skus_id_seq OWNED BY skr_skus.id;


--
-- Name: skr_so_allocation_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_so_allocation_details AS
    SELECT sol.sales_order_id, count(*) AS number_of_lines, sum(((sol.qty_allocated)::numeric * sol.price)) AS allocated_total, sum(CASE WHEN (((sol.qty_allocated - sol.qty_canceled) - sol.qty_picking) > 0) THEN 1 ELSE 0 END) AS number_of_lines_allocated, sum(CASE WHEN (sol.qty_allocated = ((sol.qty - sol.qty_canceled) - sol.qty_picking)) THEN 1 ELSE 0 END) AS number_of_lines_fully_allocated FROM ((skr_so_lines sol JOIN skr_sku_locs sl ON ((sl.id = sol.sku_loc_id))) JOIN skr_skus s ON (((s.id = sl.sku_id) AND (s.is_other_charge = false)))) GROUP BY sol.sales_order_id HAVING (sum(CASE WHEN (((sol.qty_allocated - sol.qty_canceled) - sol.qty_picking) > 0) THEN 1 ELSE 0 END) > 0);


--
-- Name: skr_so_amount_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_so_amount_details AS
    SELECT so.id AS sales_order_id, to_char((so.order_date)::timestamp with time zone, 'YYYY-MM-DD'::text) AS string_order_date, cust.code AS customer_code, cust.name AS customer_name, addr.name AS bill_addr_name, COALESCE(ttls.total, 0.0) AS total, COALESCE(ttls.num_lines, (0)::bigint) AS num_lines, COALESCE(ttls.other_charge_total, (0)::numeric) AS total_other_charge_amount, COALESCE(ttls.tax_charge_total, (0)::numeric) AS total_tax_amount, COALESCE(ttls.shipping_charge_total, (0)::numeric) AS total_shipping_amount, (COALESCE(ttls.total, 0.0) - COALESCE(ttls.other_charge_total, 0.0)) AS subtotal_amount FROM (((skr_sales_orders so JOIN skr_customers cust ON ((cust.id = so.customer_id))) JOIN skr_addresses addr ON ((addr.id = so.billing_address_id))) LEFT JOIN (SELECT sol.sales_order_id, sum(((sol.qty)::numeric * sol.price)) AS total, sum(CASE WHEN s.is_other_charge THEN ((sol.qty)::numeric * sol.price) ELSE (0)::numeric END) AS other_charge_total, sum(CASE WHEN ((sol.sku_code)::text = 'SHIP'::text) THEN ((sol.qty)::numeric * sol.price) ELSE (0)::numeric END) AS shipping_charge_total, sum(CASE WHEN ((sol.sku_code)::text = 'TAX'::text) THEN ((sol.qty)::numeric * sol.price) ELSE (0)::numeric END) AS tax_charge_total, count(sol.*) AS num_lines FROM ((skr_so_lines sol JOIN skr_sku_locs sl ON ((sl.id = sol.sku_loc_id))) JOIN skr_skus s ON ((s.id = sl.sku_id))) GROUP BY sol.sales_order_id) ttls ON ((ttls.sales_order_id = so.id)));


--
-- Name: skr_so_dailly_sales_history; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW skr_so_dailly_sales_history AS
    SELECT days_ago.days_ago, date_trunc('day'::text, ((('now'::text)::date - days_ago.days_ago))::timestamp with time zone) AS day, COALESCE(ttls.order_count, (0)::bigint) AS order_count, COALESCE(ttls.line_count, (0)::bigint) AS line_count, COALESCE(ttls.total, 0.0) AS total FROM (generate_series(0, 120, 1) days_ago(days_ago) LEFT JOIN (SELECT count(DISTINCT sol.sales_order_id) AS order_count, count(*) AS line_count, sum((sol.price * (sol.qty)::numeric)) AS total, date_trunc('day'::text, so.created_at) AS so_date FROM (skr_so_lines sol JOIN skr_sales_orders so ON ((sol.sales_order_id = so.id))) GROUP BY date_trunc('day'::text, so.created_at)) ttls ON ((ttls.so_date = date_trunc('day'::text, ((('now'::text)::date - days_ago.days_ago))::timestamp with time zone)))) ORDER BY date_trunc('day'::text, ((('now'::text)::date - days_ago.days_ago))::timestamp with time zone) DESC;


--
-- Name: skr_so_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_so_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_so_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_so_lines_id_seq OWNED BY skr_so_lines.id;


--
-- Name: skr_uoms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_uoms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_uoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_uoms_id_seq OWNED BY skr_uoms.id;


--
-- Name: skr_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_users (
    id integer NOT NULL,
    login character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_digest character varying(255) NOT NULL,
    role_names character varying(255)[] DEFAULT '{}'::character varying[] NOT NULL,
    options hstore DEFAULT ''::hstore NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_users_id_seq OWNED BY skr_users.id;


--
-- Name: skr_vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_vendors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_vendors_id_seq OWNED BY skr_vendors.id;


--
-- Name: skr_vo_lines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_vo_lines (
    id integer NOT NULL,
    voucher_id integer NOT NULL,
    sku_vendor_id integer NOT NULL,
    po_line_id integer,
    sku_code character varying(255) NOT NULL,
    part_code character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    uom_code character varying(255) NOT NULL,
    uom_size smallint NOT NULL,
    "position" smallint NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    price numeric(15,2) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_vo_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_vo_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_vo_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_vo_lines_id_seq OWNED BY skr_vo_lines.id;


--
-- Name: skr_vouchers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE skr_vouchers (
    id integer NOT NULL,
    visible_id integer NOT NULL,
    vendor_id integer NOT NULL,
    purchase_order_id integer,
    terms_id integer NOT NULL,
    state character varying(255) NOT NULL,
    refno character varying(255),
    confirmation_date date,
    created_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: skr_vouchers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE skr_vouchers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skr_vouchers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE skr_vouchers_id_seq OWNED BY skr_vouchers.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_addresses ALTER COLUMN id SET DEFAULT nextval('skr_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customers ALTER COLUMN id SET DEFAULT nextval('skr_customers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_accounts ALTER COLUMN id SET DEFAULT nextval('skr_gl_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_manual_entries ALTER COLUMN id SET DEFAULT nextval('skr_gl_manual_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_periods ALTER COLUMN id SET DEFAULT nextval('skr_gl_periods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_postings ALTER COLUMN id SET DEFAULT nextval('skr_gl_postings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_transactions ALTER COLUMN id SET DEFAULT nextval('skr_gl_transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_ia_lines ALTER COLUMN id SET DEFAULT nextval('skr_ia_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_ia_reasons ALTER COLUMN id SET DEFAULT nextval('skr_ia_reasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inv_lines ALTER COLUMN id SET DEFAULT nextval('skr_inv_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inventory_adjustments ALTER COLUMN id SET DEFAULT nextval('skr_inventory_adjustments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices ALTER COLUMN id SET DEFAULT nextval('skr_invoices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_locations ALTER COLUMN id SET DEFAULT nextval('skr_locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_payment_terms ALTER COLUMN id SET DEFAULT nextval('skr_payment_terms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pick_tickets ALTER COLUMN id SET DEFAULT nextval('skr_pick_tickets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_lines ALTER COLUMN id SET DEFAULT nextval('skr_po_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_receipts ALTER COLUMN id SET DEFAULT nextval('skr_po_receipts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_por_lines ALTER COLUMN id SET DEFAULT nextval('skr_por_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pt_lines ALTER COLUMN id SET DEFAULT nextval('skr_pt_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_purchase_orders ALTER COLUMN id SET DEFAULT nextval('skr_purchase_orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sales_orders ALTER COLUMN id SET DEFAULT nextval('skr_sales_orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_locs ALTER COLUMN id SET DEFAULT nextval('skr_sku_locs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_trans ALTER COLUMN id SET DEFAULT nextval('skr_sku_trans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_vendors ALTER COLUMN id SET DEFAULT nextval('skr_sku_vendors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_skus ALTER COLUMN id SET DEFAULT nextval('skr_skus_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_so_lines ALTER COLUMN id SET DEFAULT nextval('skr_so_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_uoms ALTER COLUMN id SET DEFAULT nextval('skr_uoms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_users ALTER COLUMN id SET DEFAULT nextval('skr_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vendors ALTER COLUMN id SET DEFAULT nextval('skr_vendors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vo_lines ALTER COLUMN id SET DEFAULT nextval('skr_vo_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vouchers ALTER COLUMN id SET DEFAULT nextval('skr_vouchers_id_seq'::regclass);


--
-- Name: skr_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_addresses
    ADD CONSTRAINT skr_addresses_pkey PRIMARY KEY (id);


--
-- Name: skr_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_customers
    ADD CONSTRAINT skr_customers_pkey PRIMARY KEY (id);


--
-- Name: skr_gl_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_gl_accounts
    ADD CONSTRAINT skr_gl_accounts_pkey PRIMARY KEY (id);


--
-- Name: skr_gl_manual_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_gl_manual_entries
    ADD CONSTRAINT skr_gl_manual_entries_pkey PRIMARY KEY (id);


--
-- Name: skr_gl_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_gl_periods
    ADD CONSTRAINT skr_gl_periods_pkey PRIMARY KEY (id);


--
-- Name: skr_gl_postings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_gl_postings
    ADD CONSTRAINT skr_gl_postings_pkey PRIMARY KEY (id);


--
-- Name: skr_gl_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_gl_transactions
    ADD CONSTRAINT skr_gl_transactions_pkey PRIMARY KEY (id);


--
-- Name: skr_ia_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_ia_lines
    ADD CONSTRAINT skr_ia_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_ia_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_ia_reasons
    ADD CONSTRAINT skr_ia_reasons_pkey PRIMARY KEY (id);


--
-- Name: skr_inv_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_inv_lines
    ADD CONSTRAINT skr_inv_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_inventory_adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_inventory_adjustments
    ADD CONSTRAINT skr_inventory_adjustments_pkey PRIMARY KEY (id);


--
-- Name: skr_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_pkey PRIMARY KEY (id);


--
-- Name: skr_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_locations
    ADD CONSTRAINT skr_locations_pkey PRIMARY KEY (id);


--
-- Name: skr_payment_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_payment_terms
    ADD CONSTRAINT skr_payment_terms_pkey PRIMARY KEY (id);


--
-- Name: skr_pick_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_pick_tickets
    ADD CONSTRAINT skr_pick_tickets_pkey PRIMARY KEY (id);


--
-- Name: skr_po_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_po_lines
    ADD CONSTRAINT skr_po_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_po_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_po_receipts
    ADD CONSTRAINT skr_po_receipts_pkey PRIMARY KEY (id);


--
-- Name: skr_por_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_por_lines
    ADD CONSTRAINT skr_por_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_pt_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_pt_lines
    ADD CONSTRAINT skr_pt_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_purchase_orders
    ADD CONSTRAINT skr_purchase_orders_pkey PRIMARY KEY (id);


--
-- Name: skr_sales_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_sales_orders
    ADD CONSTRAINT skr_sales_orders_pkey PRIMARY KEY (id);


--
-- Name: skr_sequential_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_sequential_ids
    ADD CONSTRAINT skr_sequential_ids_pkey PRIMARY KEY (name);


--
-- Name: skr_sku_locs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_sku_locs
    ADD CONSTRAINT skr_sku_locs_pkey PRIMARY KEY (id);


--
-- Name: skr_sku_trans_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_sku_trans
    ADD CONSTRAINT skr_sku_trans_pkey PRIMARY KEY (id);


--
-- Name: skr_sku_vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_sku_vendors
    ADD CONSTRAINT skr_sku_vendors_pkey PRIMARY KEY (id);


--
-- Name: skr_skus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_skus
    ADD CONSTRAINT skr_skus_pkey PRIMARY KEY (id);


--
-- Name: skr_so_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_so_lines
    ADD CONSTRAINT skr_so_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_uoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_uoms
    ADD CONSTRAINT skr_uoms_pkey PRIMARY KEY (id);


--
-- Name: skr_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_users
    ADD CONSTRAINT skr_users_pkey PRIMARY KEY (id);


--
-- Name: skr_vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_vendors
    ADD CONSTRAINT skr_vendors_pkey PRIMARY KEY (id);


--
-- Name: skr_vo_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_vo_lines
    ADD CONSTRAINT skr_vo_lines_pkey PRIMARY KEY (id);


--
-- Name: skr_vouchers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY skr_vouchers
    ADD CONSTRAINT skr_vouchers_pkey PRIMARY KEY (id);


--
-- Name: index_skr_customers_on_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_skr_customers_on_code ON skr_customers USING btree (code);


--
-- Name: index_skr_gl_postings_on_period_and_year_and_account_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_skr_gl_postings_on_period_and_year_and_account_number ON skr_gl_postings USING btree (period, year, account_number);


--
-- Name: index_skr_locations_on_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_skr_locations_on_code ON skr_locations USING btree (code);


--
-- Name: index_skr_payment_terms_on_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_skr_payment_terms_on_code ON skr_payment_terms USING btree (code);


--
-- Name: index_skr_users_on_role_names; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_skr_users_on_role_names ON skr_users USING gin (role_names);


--
-- Name: skr_gl_manual_entriesindx_visible_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skr_gl_manual_entriesindx_visible_id ON skr_gl_manual_entries USING btree (((visible_id)::character varying));


--
-- Name: skr_inventory_adjustmentsindx_visible_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skr_inventory_adjustmentsindx_visible_id ON skr_inventory_adjustments USING btree (((visible_id)::character varying));


--
-- Name: skr_invoicesindx_visible_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skr_invoicesindx_visible_id ON skr_invoices USING btree (((visible_id)::character varying));


--
-- Name: skr_pick_ticketsindx_visible_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skr_pick_ticketsindx_visible_id ON skr_pick_tickets USING btree (((visible_id)::character varying));


--
-- Name: skr_po_receiptsindx_visible_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skr_po_receiptsindx_visible_id ON skr_po_receipts USING btree (((visible_id)::character varying));


--
-- Name: skr_purchase_ordersindx_visible_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skr_purchase_ordersindx_visible_id ON skr_purchase_orders USING btree (((visible_id)::character varying));


--
-- Name: skr_sales_ordersindx_visible_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skr_sales_ordersindx_visible_id ON skr_sales_orders USING btree (((visible_id)::character varying));


--
-- Name: skr_vouchersindx_visible_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX skr_vouchersindx_visible_id ON skr_vouchers USING btree (((visible_id)::character varying));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: skr_customers_gl_receivables_account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customers
    ADD CONSTRAINT skr_customers_gl_receivables_account_id_fk FOREIGN KEY (gl_receivables_account_id) REFERENCES skr_gl_accounts(id);


--
-- Name: skr_customers_shipping_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customers
    ADD CONSTRAINT skr_customers_shipping_address_id_fk FOREIGN KEY (shipping_address_id) REFERENCES skr_addresses(id);


--
-- Name: skr_customers_terms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_customers
    ADD CONSTRAINT skr_customers_terms_id_fk FOREIGN KEY (terms_id) REFERENCES skr_payment_terms(id);


--
-- Name: skr_gl_postings_gl_transaction_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_postings
    ADD CONSTRAINT skr_gl_postings_gl_transaction_id_fk FOREIGN KEY (gl_transaction_id) REFERENCES skr_gl_transactions(id);


--
-- Name: skr_gl_transactions_period_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_gl_transactions
    ADD CONSTRAINT skr_gl_transactions_period_id_fk FOREIGN KEY (period_id) REFERENCES skr_gl_periods(id);


--
-- Name: skr_ia_lines_inventory_adjustment_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_ia_lines
    ADD CONSTRAINT skr_ia_lines_inventory_adjustment_id_fk FOREIGN KEY (inventory_adjustment_id) REFERENCES skr_inventory_adjustments(id);


--
-- Name: skr_ia_lines_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_ia_lines
    ADD CONSTRAINT skr_ia_lines_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_ia_reasons_gl_account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_ia_reasons
    ADD CONSTRAINT skr_ia_reasons_gl_account_id_fk FOREIGN KEY (gl_account_id) REFERENCES skr_gl_accounts(id);


--
-- Name: skr_inv_lines_invoice_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inv_lines
    ADD CONSTRAINT skr_inv_lines_invoice_id_fk FOREIGN KEY (invoice_id) REFERENCES skr_invoices(id);


--
-- Name: skr_inv_lines_pt_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inv_lines
    ADD CONSTRAINT skr_inv_lines_pt_line_id_fk FOREIGN KEY (pt_line_id) REFERENCES skr_pt_lines(id);


--
-- Name: skr_inv_lines_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inv_lines
    ADD CONSTRAINT skr_inv_lines_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_inv_lines_so_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inv_lines
    ADD CONSTRAINT skr_inv_lines_so_line_id_fk FOREIGN KEY (so_line_id) REFERENCES skr_so_lines(id);


--
-- Name: skr_inventory_adjustments_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inventory_adjustments
    ADD CONSTRAINT skr_inventory_adjustments_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_inventory_adjustments_reason_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_inventory_adjustments
    ADD CONSTRAINT skr_inventory_adjustments_reason_id_fk FOREIGN KEY (reason_id) REFERENCES skr_ia_reasons(id);


--
-- Name: skr_invoices_billing_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_billing_address_id_fk FOREIGN KEY (billing_address_id) REFERENCES skr_addresses(id);


--
-- Name: skr_invoices_customer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_customer_id_fk FOREIGN KEY (customer_id) REFERENCES skr_customers(id);


--
-- Name: skr_invoices_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_invoices_pick_ticket_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_pick_ticket_id_fk FOREIGN KEY (pick_ticket_id) REFERENCES skr_pick_tickets(id);


--
-- Name: skr_invoices_sales_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_sales_order_id_fk FOREIGN KEY (sales_order_id) REFERENCES skr_sales_orders(id);


--
-- Name: skr_invoices_terms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_invoices
    ADD CONSTRAINT skr_invoices_terms_id_fk FOREIGN KEY (terms_id) REFERENCES skr_payment_terms(id);


--
-- Name: skr_locations_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_locations
    ADD CONSTRAINT skr_locations_address_id_fk FOREIGN KEY (address_id) REFERENCES skr_addresses(id);


--
-- Name: skr_pick_tickets_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pick_tickets
    ADD CONSTRAINT skr_pick_tickets_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_pick_tickets_sales_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pick_tickets
    ADD CONSTRAINT skr_pick_tickets_sales_order_id_fk FOREIGN KEY (sales_order_id) REFERENCES skr_sales_orders(id);


--
-- Name: skr_po_lines_purchase_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_lines
    ADD CONSTRAINT skr_po_lines_purchase_order_id_fk FOREIGN KEY (purchase_order_id) REFERENCES skr_purchase_orders(id);


--
-- Name: skr_po_lines_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_lines
    ADD CONSTRAINT skr_po_lines_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_po_lines_sku_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_lines
    ADD CONSTRAINT skr_po_lines_sku_vendor_id_fk FOREIGN KEY (sku_vendor_id) REFERENCES skr_sku_vendors(id);


--
-- Name: skr_po_receipts_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_receipts
    ADD CONSTRAINT skr_po_receipts_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_po_receipts_purchase_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_receipts
    ADD CONSTRAINT skr_po_receipts_purchase_order_id_fk FOREIGN KEY (purchase_order_id) REFERENCES skr_purchase_orders(id);


--
-- Name: skr_po_receipts_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_receipts
    ADD CONSTRAINT skr_po_receipts_vendor_id_fk FOREIGN KEY (vendor_id) REFERENCES skr_vendors(id);


--
-- Name: skr_po_receipts_voucher_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_po_receipts
    ADD CONSTRAINT skr_po_receipts_voucher_id_fk FOREIGN KEY (voucher_id) REFERENCES skr_vouchers(id);


--
-- Name: skr_por_lines_po_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_por_lines
    ADD CONSTRAINT skr_por_lines_po_line_id_fk FOREIGN KEY (po_line_id) REFERENCES skr_po_lines(id);


--
-- Name: skr_por_lines_po_receipt_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_por_lines
    ADD CONSTRAINT skr_por_lines_po_receipt_id_fk FOREIGN KEY (po_receipt_id) REFERENCES skr_po_receipts(id);


--
-- Name: skr_por_lines_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_por_lines
    ADD CONSTRAINT skr_por_lines_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_por_lines_sku_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_por_lines
    ADD CONSTRAINT skr_por_lines_sku_vendor_id_fk FOREIGN KEY (sku_vendor_id) REFERENCES skr_sku_vendors(id);


--
-- Name: skr_pt_lines_pick_ticket_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pt_lines
    ADD CONSTRAINT skr_pt_lines_pick_ticket_id_fk FOREIGN KEY (pick_ticket_id) REFERENCES skr_pick_tickets(id);


--
-- Name: skr_pt_lines_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pt_lines
    ADD CONSTRAINT skr_pt_lines_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_pt_lines_so_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_pt_lines
    ADD CONSTRAINT skr_pt_lines_so_line_id_fk FOREIGN KEY (so_line_id) REFERENCES skr_so_lines(id);


--
-- Name: skr_purchase_orders_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_purchase_orders
    ADD CONSTRAINT skr_purchase_orders_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_purchase_orders_ship_addr_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_purchase_orders
    ADD CONSTRAINT skr_purchase_orders_ship_addr_id_fk FOREIGN KEY (ship_addr_id) REFERENCES skr_addresses(id);


--
-- Name: skr_purchase_orders_terms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_purchase_orders
    ADD CONSTRAINT skr_purchase_orders_terms_id_fk FOREIGN KEY (terms_id) REFERENCES skr_payment_terms(id);


--
-- Name: skr_purchase_orders_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_purchase_orders
    ADD CONSTRAINT skr_purchase_orders_vendor_id_fk FOREIGN KEY (vendor_id) REFERENCES skr_vendors(id);


--
-- Name: skr_sales_orders_billing_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sales_orders
    ADD CONSTRAINT skr_sales_orders_billing_address_id_fk FOREIGN KEY (billing_address_id) REFERENCES skr_addresses(id);


--
-- Name: skr_sales_orders_customer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sales_orders
    ADD CONSTRAINT skr_sales_orders_customer_id_fk FOREIGN KEY (customer_id) REFERENCES skr_customers(id);


--
-- Name: skr_sales_orders_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sales_orders
    ADD CONSTRAINT skr_sales_orders_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_sales_orders_terms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sales_orders
    ADD CONSTRAINT skr_sales_orders_terms_id_fk FOREIGN KEY (terms_id) REFERENCES skr_payment_terms(id);


--
-- Name: skr_sku_locs_location_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_locs
    ADD CONSTRAINT skr_sku_locs_location_id_fk FOREIGN KEY (location_id) REFERENCES skr_locations(id);


--
-- Name: skr_sku_locs_sku_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_locs
    ADD CONSTRAINT skr_sku_locs_sku_id_fk FOREIGN KEY (sku_id) REFERENCES skr_skus(id);


--
-- Name: skr_sku_trans_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_trans
    ADD CONSTRAINT skr_sku_trans_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_sku_vendors_sku_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_vendors
    ADD CONSTRAINT skr_sku_vendors_sku_id_fk FOREIGN KEY (sku_id) REFERENCES skr_skus(id);


--
-- Name: skr_sku_vendors_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_sku_vendors
    ADD CONSTRAINT skr_sku_vendors_vendor_id_fk FOREIGN KEY (vendor_id) REFERENCES skr_vendors(id);


--
-- Name: skr_skus_default_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_skus
    ADD CONSTRAINT skr_skus_default_vendor_id_fk FOREIGN KEY (default_vendor_id) REFERENCES skr_vendors(id);


--
-- Name: skr_skus_gl_asset_account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_skus
    ADD CONSTRAINT skr_skus_gl_asset_account_id_fk FOREIGN KEY (gl_asset_account_id) REFERENCES skr_gl_accounts(id);


--
-- Name: skr_so_lines_sales_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_so_lines
    ADD CONSTRAINT skr_so_lines_sales_order_id_fk FOREIGN KEY (sales_order_id) REFERENCES skr_sales_orders(id);


--
-- Name: skr_so_lines_sku_loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_so_lines
    ADD CONSTRAINT skr_so_lines_sku_loc_id_fk FOREIGN KEY (sku_loc_id) REFERENCES skr_sku_locs(id);


--
-- Name: skr_uoms_sku_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_uoms
    ADD CONSTRAINT skr_uoms_sku_id_fk FOREIGN KEY (sku_id) REFERENCES skr_skus(id);


--
-- Name: skr_vendors_gl_freight_account_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vendors
    ADD CONSTRAINT skr_vendors_gl_freight_account_id_fk FOREIGN KEY (gl_freight_account_id) REFERENCES skr_gl_accounts(id);


--
-- Name: skr_vendors_shipping_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vendors
    ADD CONSTRAINT skr_vendors_shipping_address_id_fk FOREIGN KEY (shipping_address_id) REFERENCES skr_addresses(id);


--
-- Name: skr_vendors_terms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vendors
    ADD CONSTRAINT skr_vendors_terms_id_fk FOREIGN KEY (terms_id) REFERENCES skr_payment_terms(id);


--
-- Name: skr_vo_lines_po_line_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vo_lines
    ADD CONSTRAINT skr_vo_lines_po_line_id_fk FOREIGN KEY (po_line_id) REFERENCES skr_po_lines(id);


--
-- Name: skr_vo_lines_sku_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vo_lines
    ADD CONSTRAINT skr_vo_lines_sku_vendor_id_fk FOREIGN KEY (sku_vendor_id) REFERENCES skr_sku_vendors(id);


--
-- Name: skr_vo_lines_voucher_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vo_lines
    ADD CONSTRAINT skr_vo_lines_voucher_id_fk FOREIGN KEY (voucher_id) REFERENCES skr_vouchers(id);


--
-- Name: skr_vouchers_purchase_order_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vouchers
    ADD CONSTRAINT skr_vouchers_purchase_order_id_fk FOREIGN KEY (purchase_order_id) REFERENCES skr_purchase_orders(id);


--
-- Name: skr_vouchers_terms_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vouchers
    ADD CONSTRAINT skr_vouchers_terms_id_fk FOREIGN KEY (terms_id) REFERENCES skr_payment_terms(id);


--
-- Name: skr_vouchers_vendor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY skr_vouchers
    ADD CONSTRAINT skr_vouchers_vendor_id_fk FOREIGN KEY (vendor_id) REFERENCES skr_vendors(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140602171842');

INSERT INTO schema_migrations (version) VALUES ('20140602171843');

INSERT INTO schema_migrations (version) VALUES ('20140602171844');

INSERT INTO schema_migrations (version) VALUES ('20140602171845');

INSERT INTO schema_migrations (version) VALUES ('20140602171846');

INSERT INTO schema_migrations (version) VALUES ('20140602171847');

INSERT INTO schema_migrations (version) VALUES ('20140602171848');

INSERT INTO schema_migrations (version) VALUES ('20140602171849');

INSERT INTO schema_migrations (version) VALUES ('20140602171850');

INSERT INTO schema_migrations (version) VALUES ('20140602171851');

INSERT INTO schema_migrations (version) VALUES ('20140602171852');

INSERT INTO schema_migrations (version) VALUES ('20140602171853');

INSERT INTO schema_migrations (version) VALUES ('20140602171854');

INSERT INTO schema_migrations (version) VALUES ('20140602171855');

INSERT INTO schema_migrations (version) VALUES ('20140602171856');

INSERT INTO schema_migrations (version) VALUES ('20140602171857');

INSERT INTO schema_migrations (version) VALUES ('20140602171858');

INSERT INTO schema_migrations (version) VALUES ('20140602171859');

INSERT INTO schema_migrations (version) VALUES ('20140602171860');

INSERT INTO schema_migrations (version) VALUES ('20140602171861');

INSERT INTO schema_migrations (version) VALUES ('20140602171862');

INSERT INTO schema_migrations (version) VALUES ('20140602171863');

INSERT INTO schema_migrations (version) VALUES ('20140602171864');

INSERT INTO schema_migrations (version) VALUES ('20140602171865');

INSERT INTO schema_migrations (version) VALUES ('20140602171866');

INSERT INTO schema_migrations (version) VALUES ('20140602171867');

INSERT INTO schema_migrations (version) VALUES ('20140602171868');

INSERT INTO schema_migrations (version) VALUES ('20140602171869');

INSERT INTO schema_migrations (version) VALUES ('20140602171870');

INSERT INTO schema_migrations (version) VALUES ('20140602171871');

INSERT INTO schema_migrations (version) VALUES ('20140602171872');

INSERT INTO schema_migrations (version) VALUES ('20140602171873');

INSERT INTO schema_migrations (version) VALUES ('20140602171874');

INSERT INTO schema_migrations (version) VALUES ('20140602171875');

INSERT INTO schema_migrations (version) VALUES ('20140602171876');

INSERT INTO schema_migrations (version) VALUES ('20140615031600');

