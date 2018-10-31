<?php

/**
 * Created by PhpStorm.
 * User: kurti
 * Email : kurtitasarim@gmail.com
 * Web Site : www.kurtitasarim.com ~ www.kurtulusoz.com.tr
 * Date: 30.10.2018
 * Time: 19:14
 */
class ControllerCatalogCategoryDiscount extends Controller
{
    private $error = array();

    public function index()
    {
        $this->language->load('catalog/category');
        $this->load->model('catalog/category');
        $this->document->setTitle($this->language->get('heading_title'));
        if (isset($this->error['warning'])) {
            $data['error_warning'] = $this->error['warning'];
        } else {
            $data['error_warning'] = '';
        }
        if (isset($this->session->data['success'])) {
            $data['success'] = $this->session->data['success'];

            unset($this->session->data['success']);
        } else {
            $data['success'] = '';
        }
        $data['breadcrumbs'] = array();
        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], 'SSL')
        );
        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title'),
            'href' => $this->url->link('catalog/category', 'token=' . $this->session->data['token'] , 'SSL')
        );
        $data['category']           = $this->model_catalog_category->getCategories();
        $data['header']             = $this->load->controller('common/header');
        $data['column_left']        = $this->load->controller('common/column_left');
        $data['footer']             = $this->load->controller('common/footer');
        $data['token']              = $this->session->data['token'];
        //
        $data['heading_title']      = 'Kategori Bazlı Fiyat işlemleri';
        $data['text_title']         = 'Fiyat işlemleri';

        $this->response->setOutput($this->load->view('catalog/category_discount.tpl', $data));
    }

    public function categoryDiscountUpdate()
    {
        $this->load->model('catalog/product');
        $kategoriID     =   (int)$this->request->post['kategoriID'];
        $islem          =   (string)$this->request->post['islem'];
        $oran           =   (int)$this->request->post['oran'];
        $product        =   $this->model_catalog_product->getProductsByCategoryId($kategoriID);
        $output         =   null;
        // işleme göre hareket çiz
        if( $islem == "indirim" )
        {
            $islem  =   "-";
        }
        elseif ( $islem == "zam" )
        {
            $islem = "+";
        }
        else{}
        foreach ( $product as $key => $item )
        {
            $sql    =   "UPDATE " . DB_PREFIX . "product SET price = price".$islem."(price/100*".$oran.") WHERE product_id = '".$item['product_id']."'";
            $qry    =   $this->db->query($sql);
            if(!$qry)
            {
                $output = array('response'=>false,'message'=>'indirim uygulamada hata var');
            }
            // indirim oranı var ise oradada indirim yapmak lazım
            $indirim    =   $this->model_catalog_product->getProductDiscounts($item['product_id']);
            if(count($indirim) > 0)
            {
                foreach ( $indirim as $indirimKey => $indirimItem ) {
                    $indirimSql = "UPDATE " . DB_PREFIX . "product_discount SET price = price" . $islem . "(price/100*" . $oran . ") WHERE product_id = '" . $indirimItem['product_discount_id'] . "'";
                    $indirimQry = $this->db->query($indirimSql);
                }
            }
            //special product
            $special    =   $this->model_catalog_product->getProductSpecials($item['product_id']);
            if(count($special) > 0)
            {
                foreach ( $indirim as $specialKey => $specialItem ) {
                    $specialSql = "UPDATE " . DB_PREFIX . "product_special SET price = price" . $islem . "(price/100*" . $oran . ") WHERE product_id = '" . $specialItem['product_special_id'] . "'";
                    $specialQry = $this->db->query($specialSql);
                }
            }
        }
        $output = array('response'=>true);
        $this->response->setOutput(json_encode($output));
    }
}