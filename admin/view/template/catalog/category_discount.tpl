<?php echo $header; ?>
<?php echo $column_left; ?>
<div id="content">
    <div class="page-header">
        <div class="container-fluid">
            <div class="pull-right"><a href="<?php echo $add; ?>" data-toggle="tooltip" title="<?php echo $button_add; ?>" class="btn btn-primary"><i class="fa fa-plus"></i></a> <a href="<?php echo $repair; ?>" data-toggle="tooltip" title="<?php echo $button_rebuild; ?>" class="btn btn-default"><i class="fa fa-refresh"></i></a>
                <button type="button" data-toggle="tooltip" title="<?php echo $button_delete; ?>" class="btn btn-danger" onclick="confirm('<?php echo $text_confirm; ?>') ? $('#form-category').submit() : false;"><i class="fa fa-trash-o"></i></button>
            </div>
            <h1><?php echo $heading_title; ?></h1>
            <ul class="breadcrumb">
                <?php foreach ($breadcrumbs as $breadcrumb) { ?>
                <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
                <?php } ?>
            </ul>
        </div>
    </div>
    <div class="container-fluid">
        <?php if ($error_warning) { ?>
        <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
        <?php } ?>
        <?php if ($success) { ?>
        <div class="alert alert-success"><i class="fa fa-check-circle"></i> <?php echo $success; ?>
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
        <?php } ?>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-list"></i> <?php echo $text_title; ?></h3>
            </div>
            <div class="panel-body">
                <div class="row">
                    <div class="form-group">
                        <div class="col-md-4">Kategori</div>
                        <div class="col-md-8">
                            <select name="kategori" class="form-control ">
                                <option value="0">Seçiniz</option>
                                <?php
                                    foreach( $category as $key => $item ){
                                ?>
                                <option value="<?php echo $item['category_id']; ?>"><?php echo $item['name']; ?></option>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <div class="col-md-4">işlem</div>
                        <div class="col-md-8">
                            <select name="islem" class="form-control ">
                                <option value="0">Seçiniz</option>
                                <option value="indirim">indirim</option>
                                <option value="zam">zam</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <div class="col-md-4">Oran</div>
                        <div class="col-md-8">
                            <input type="text" name="oran" placeholder="% indirim uygulanacak" class="form-control">
                        </div>
                    </div>
                </div>
                    <div class="form-group">
                      <button type="button" id="guncelle" class="btn btn-sm btn-info">Güncelle</button>
                    </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(window).on('load ready',function(e){
        $('button#guncelle').on('click',function(){
            // console.log(window.location.origin);
            var _kategori   =   $('select[name=kategori]');
            var _islem      =   $('select[name=islem]');
            var _oran       =   $('input[name=oran]');
            if( _kategori.val() == 0 )
            {
                alert('ilk olarak kategori seçimi yapınız');
                return false;
            }
            if( _islem.val() == 0 )
            {
                alert('işlem seçimi yapınız');
                return false;
            }
            if( _oran.val() == 0 )
            {
                alert('Oran seçimi yapınız');
                return false;
            }
            data    =   { kategoriID : _kategori.val(), islem : _islem.val(), oran : _oran.val() };
            // console.log(data);
            $.ajax({
                type    :   'post',
                url     :   window.location.origin+'/admin/index.php?route=catalog/category_discount/categoryDiscountUpdate&token=<?php echo $token; ?>',
                data    :   data,
                success :   function (suc) {
                    // console.log(suc);
                    if(suc)
                    {
                        alert('Seçtiğiniz kategori olan '+$('select[name=kategori] option:selected').text()+' ait ürün fiyatlarına %'+_oran.val()+' oranında '+$('select[name=islem] option:selected').text()+' uygulandı');
                        _kategori.prop('selectedIndex',0);
                        _islem.prop('selectedIndex',0);
                        _oran.val('');
                    }
                },
                error   :   function (err) {
                    console.log(err);
                }
            });
        });
    });
</script>