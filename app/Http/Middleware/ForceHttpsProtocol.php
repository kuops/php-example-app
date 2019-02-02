
<?php
 
namespace App\Http\Middleware;
 
use Closure;
 
class ForceHttpsProtocol {
 
    public function handle($request, Closure $next) {
 
        if (!$request->secure() && env('APP_ENV') === 'pro') {
            return redirect()->secure($request->getRequestUri());
        }
 
        return $next($request);
    }
 
}
