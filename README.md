
<script src="https://sdk.jinrishici.com/v2/browser/jinrishici.js" charset="utf-8"></script>


<div style="position: relative;width: 800px;padding: 20px;background-color: #fff;box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);border-radius: 8px;margin-bottom:200px;">
    <div style="text-align: center;margin-bottom: 30px;font-size: 20px;letter-spacing: 2px;margin-left:-315px;">
        <div id="poem_sentence"></div>
    </div>
    <div style="position: absolute;bottom: 10px;right: 20px;font-style: italic;font-size: 0.9em;color: #555;margin-left:-315px">
        <div id="poem_info"></div>
    </div>
</div>

<script type="text/javascript">
    jinrishici.load(function(result) {
        var sentence = document.querySelector("#poem_sentence")
        var info = document.querySelector("#poem_info")
        var trans = document.querySelector("#poem_trans")
        sentence.innerHTML = result.data.content
        info.innerHTML = '【' + result.data.origin.dynasty + '】' + result.data.origin.author + '《' + result.data.origin.title + '》'
    });
</script>

